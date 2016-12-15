class InFutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, (options[:message] || :in_future)) unless in_future?(value)
  end

  def in_future?(date)
    date.present? && date > Time.zone.today
  end
end