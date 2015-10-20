class ThesaTerm < Sequel::Model(:thesa_term)
  include ASModel
  corresponds_to JSONModel(:thesa_term)

  set_model_scope :repository

end
