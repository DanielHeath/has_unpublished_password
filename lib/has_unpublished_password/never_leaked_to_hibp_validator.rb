# Must be a top-level constant so rails can find it.

class NeverLeakedToHibpValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if HasUnpublishedPassword.has_been_published? value
      record.errors[attribute] << (options[:message] || "That's one of the first passwords a hacker would try.")
    end
  end
end
