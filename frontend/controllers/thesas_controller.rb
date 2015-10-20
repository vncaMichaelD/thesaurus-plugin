class ThesasController < ApplicationController

  set_access_control  "view_repository" => [:index, :show],
                      "update_resource_record" => [:new, :edit, :create, :update],
                      "transfer_archival_record" => [:transfer],
                      "suppress_archival_record" => [:suppress, :unsuppress],
                      "delete_archival_record" => [:delete],
                      "manage_repository" => [:defaults, :update_defaults]



  def index
    @search_data = Search.for_type(session[:repo_id], "thesa", params_for_backend_search.merge({"facet[]" => SearchResultData.ACCESSION_FACETS}))
  end


  def show
    @thesa = fetch_resolved(params[:id])
  end

  def new
    @thesa = Thesa.new({:thesa_date => Date.today.strftime('%Y-%m-%d')})._always_valid!

    if params[:thesa_id]
      tes = Thesa.find(params[:thesa_id], find_opts)

      if tes
        @thesa.populate_from_thesa(tes)
        flash.now[:info] = I18n.t("thesa._frontend.messages.spawned", JSONModelI18nWrapper.new(:thesa => tes))
        flash[:spawned_from_thesa] = tes.id
      end

    elsif user_prefs['default_values']
      defaults = DefaultValues.get 'thesa'

      if defaults
        @thesa.update(defaults.values)
      end
    end

  end



  def defaults
    defaults = DefaultValues.get 'thesa'

    values = defaults ? defaults.form_values : {:thesa_date => Date.today.strftime('%Y-%m-%d')}

    @thesa = Thesa.new(values)._always_valid!

    render "defaults"
  end


  def update_defaults

    begin
      DefaultValues.from_hash({
                                "record_type" => "thesa",
                                "lock_version" => params[:thesa].delete('lock_version'),
                                "defaults" => cleanup_params_for_schema(
                                                                        params[:thesa],
                                                                        JSONModel(:thesa).schema
                                                                        )
                              }).save

      flash[:success] = I18n.t("default_values.messages.defaults_updated")

      redirect_to :controller => :thesas, :action => :defaults
    rescue Exception => e
      flash[:error] = e.message
      redirect_to :controller => :thesas, :action => :defaults
    end

  end

  def edit
    @thesa = fetch_resolved(params[:id])

    if @thesa.suppressed
      redirect_to(:controller => :thesas, :action => :show, :id => params[:id])
    end
  end



  def create
    handle_crud(:instance => :thesa,
                :model => Thesa,
                :on_invalid => ->(){ render action: "new" },
                :on_valid => ->(id){
                    flash[:success] = I18n.t("thesa._frontend.messages.created", JSONModelI18nWrapper.new(:thesa => @thesa))
                    redirect_to(:controller => :thesas,
                                :action => :edit,
                                :id => id) })
  end

  def update
    handle_crud(:instance => :thesa,
                :model => Thesa,
                :obj => fetch_resolved(params[:id]),
                :on_invalid => ->(){
                  return render action: "edit"
                },
                :on_valid => ->(id){
                  flash[:success] = I18n.t("thesa._frontend.messages.updated", JSONModelI18nWrapper.new(:thesa => @thesa))
                  redirect_to :controller => :thesas, :action => :edit, :id => id
                })
  end


  def delete
    thesa = Thesa.find(params[:id])
    thesa.delete

    flash[:success] = I18n.t("thesa._frontend.messages.deleted", JSONModelI18nWrapper.new(:thesa => thesa))
    redirect_to(:controller => :thesas, :action => :index, :deleted_uri => thesa.uri)
  end


  private

  # refactoring note: suspiciously similar to resources_controller.rb
  def fetch_resolved(id)
    thesa = Thesa.find(id, find_opts)

    thesa
  end


end
