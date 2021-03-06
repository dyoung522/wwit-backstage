class Conflict < ActiveRecord::Base
  before_create  :log_create
  before_destroy :log_destroy

  belongs_to :member

  scope :for_date, ->(date = Date.today) do
    if my_date = Date.parse(date.to_s)
      where(year: my_date.year).where(month: my_date.month).where(day: my_date.day)
    end
  end
  scope :for_month, ->(month, year = Date.today.year) { where(year: year).where(month: month) }
  scope :for_year,  ->(year) { where(year: year) }

  scope :next_month, -> { for_month( (Date.today - 1.month).month, (Date.today - 1.month).year) }
  scope :this_month, -> { for_month( Date.today.month ) }
  scope :next_month, -> { for_month( (Date.today + 1.month).month, (Date.today + 1.month).year) }
  scope :this_year,  -> { for_year( Date.today.year ) }

  scope :current, -> { this_month | next_month }
  scope :current_and_future, -> { current | future }
  scope :future,  -> { where('year >= ?', Date.today.year).where('month > ?', Date.today.month) }

  scope :by_date, -> { order([:year, :month, :day]) }

  # default_scope -> { by_date }

  def date
    '%4d-%02d-%02d' % [year, month, day]
  end

  def us_date
    '%02d/%02d/%4d' % [month, day, year]
  end

  def datetime
    date.to_time
  end

  def locked?
    lock?
  end

  def lock!
    return if locked?
    Audit.logger self.class.to_s, "Conflict for #{self.member.name} on #{self.date} locked in"
    self.lock = true
    self.save
  end

  def log_create
    return if ENV['RAILS_ENV'] == 'test'
    Audit.logger self.class.to_s, "Conflict created for #{self.member.name} on #{self.date}"
  end

  def log_destroy
    return if ENV['RAILS_ENV'] == 'test'
    Audit.logger self.class.to_s, "Conflict removed for #{self.member.name} on #{self.date}"
  end

end
