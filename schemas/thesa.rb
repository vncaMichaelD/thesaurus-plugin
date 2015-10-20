{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",
    "uri" => "/repositories/:repo_id/thesas",
    "properties" => {
	  "subject" => {"type" => "string", "dynamic_enum" => "thesa_subject"},
	  "general_note" => {"type" => "string", "maxLength" => 8192},
      "uri" => {"type" => "string", "required" => false},
      "thesa_terms" => {"type" => "array", "ifmissing" => "error", "minItems" => 1, "items" => {"type" => "JSONModel(:thesa_term) object"}},

      "suppressed" => {"type" => "boolean", "default" => false},
      "display_string" => {"type" => "string", "maxLength" => 8192, "readonly" => true},
    },
  },
}