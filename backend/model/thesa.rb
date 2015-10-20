class Thesa < Sequel::Model(:thesa)
  include ASModel
  corresponds_to JSONModel(:thesa)

  include ThesaTerms

  set_model_scope :repository


  def self.sequel_to_jsonmodel(objs, opts = {})
    jsons = super

    jsons.zip(objs).each do |json, obj|
      p json

      terms = ASUtils.wrap(json['thesa_terms']).map {|term| term['term']}.join(" -- ")

      if !terms.empty?
        json['display_string'] = "#{terms}"
      end
    end

    jsons
  end

end