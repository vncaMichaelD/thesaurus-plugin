{
  :schema => {
    "$schema" => "http://www.archivesspace.org/archivesspace.json",
    "version" => 1,
    "type" => "object",

    "properties" => {
	  "term" => {"type" => "string", "maxLength" => 255, "ifmissing" => "error"},
      "preferred" => {"type" => "boolean", "default" => false},

    },
  },
}
