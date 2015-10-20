class ArchivesSpaceService < Sinatra::Base

  Endpoint.post('/repositories/:repo_id/thesas/:id')
    .description("Update a Thesaurus term")
    .params(["id", :id],
            ["thesa", JSONModel(:thesa), "The updated record", :body => true],
            ["repo_id", :repo_id])
    .permissions([:update_resource_record])
    .returns([200, :updated]) \
  do
    handle_update(Thesa, params[:id], params[:thesa])
  end


  Endpoint.post('/repositories/:repo_id/thesas')
    .description("Create a Thesaurus term")
    .params(["thesa", JSONModel(:thesa), "The record to create", :body => true],
            ["repo_id", :repo_id])
    .permissions([:update_resource_record])
    .returns([200, :created]) \
  do
    handle_create(Thesa, params[:thesa])
  end


  Endpoint.get('/repositories/:repo_id/thesas')
    .description("Get a list of Thesaurus terms for a Repository")
    .params(["repo_id", :repo_id])
    .paginated(true)
    .permissions([:view_repository])
    .returns([200, "[(:thesa)]"]) \
  do
    handle_listing(Thesa, params)
  end


  Endpoint.get('/repositories/:repo_id/thesas/:id')
    .description("Get a Thesaurus term by ID")
    .params(["id", :id],
            ["repo_id", :repo_id],
            ["resolve", :resolve])
    .permissions([:view_repository])
    .returns([200, "(:thesa)"]) \
  do
    json = Thesa.to_jsonmodel(params[:id])

    json_response(resolve_references(json, params[:resolve]))
  end


  Endpoint.delete('/repositories/:repo_id/thesas/:id')
    .description("Delete a Thesaurus term")
    .params(["id", :id],
            ["repo_id", :repo_id])
    .permissions([:delete_archival_record])
    .returns([200, :deleted]) \
  do
    handle_delete(Thesa, params[:id])
  end

end