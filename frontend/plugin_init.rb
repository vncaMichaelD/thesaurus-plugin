my_routes = [File.join(File.dirname(__FILE__), "routes.rb")]
ArchivesSpace::Application.config.paths['config/routes'].concat(my_routes)

ArchivesSpace::Application.config.after_initialize do
 
   # Force the module to load
   SearchHelper
 
   module SearchHelper
 
    def can_edit_search_result?(record)
      return user_can?('manage_repository', record['id']) if record['primary_type'] === "repository"
      return user_can?('update_location_record') if record['primary_type'] === "location"
      return user_can?('update_subject_record') if record['primary_type'] === "subject"
      return user_can?('update_classification_record') if ["classification", "classification_term"].include?(record['primary_type'])
      return user_can?('update_agent_record') if Array(record['types']).include?("agent")

      return user_can?('update_resource_record') if record['primary_type'] === "thesa"
      return user_can?('update_accession_record') if record['primary_type'] === "accession"
      return user_can?('update_resource_record') if ["resource", "archival_object"].include?(record['primary_type'])
      return user_can?('update_digital_object_record') if ["digital_object", "digital_object_component"].include?(record['primary_type'])
    end

   end
 
 end