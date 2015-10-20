module ThesaTerms

  def self.included(base)
        base.one_to_many :thesa_term


        base.def_nested_record(:the_property => :thesa_terms,
                               :contains_records_of_type => :thesa_term,
                               :corresponding_to_association => :thesa_term)
  end

end
