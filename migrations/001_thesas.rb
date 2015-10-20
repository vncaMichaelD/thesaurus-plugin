Sequel.migration do

  up do
    $stderr.puts("Adding VVA Thesaurus table, fields, and constraints.")

    create_table(:thesa) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :subject_id
      String :term
      TextField :general_note

      apply_mtime_columns

	  Integer :star_record
    end

    create_table(:thesa_term) do
      primary_key :id

      Integer :lock_version, :default => 0, :null => false
      Integer :json_schema_version, :null => false

      Integer :thesa_id
      String :term
      Integer :preferred

      apply_mtime_columns

	  Integer :star_record
	  Integer :occ
    end

    create_editable_enum('thesa_subject', ["placename", "militaryterm", "militarytitle", "odp"])
  end

end
