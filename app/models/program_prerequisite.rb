class ProgramPrerequisite < ApplicationRecord
  belongs_to :program
  belongs_to :prerequisite_program, class_name: 'Program'

  validates :program_id, uniqueness: { scope: :prerequisite_program_id }
  validate :no_self_reference
  validate :no_circular_dependency

  private

  def no_self_reference
    if program_id == prerequisite_program_id
      errors.add(:base, 'A program cannot be a prerequisite for itself')
    end
  end

  def no_circular_dependency
    return unless program_id && prerequisite_program_id

    if prerequisite_program.prerequisites.exists?(prerequisite_program_id: program_id)
      errors.add(:base, 'Circular dependency detected')
    end
  end
end 