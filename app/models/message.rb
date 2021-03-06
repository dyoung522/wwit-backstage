class Message < ActiveRecord::Base
  include MessagesHelper

  has_and_belongs_to_many :members, autosave: true
  belongs_to :sender,   class_name: Member, :foreign_key => :sender_id
  belongs_to :approver, class_name: Member, :foreign_key => :approver_id
  before_save :check_and_add_members

  scope :by_created,   -> { order(:created_at   => :desc) }
  scope :by_sent,      -> { order(:sent_at      => :desc) }
  scope :by_delivered, -> { order(:delivered_at => :desc) }

  scope :recent,   -> { where('messages.created_at >= ?', (Date.today - 2.weeks) ) }
  scope :approved, -> { where.not(approver: nil) }

  scope :for_member, ->(member) {
    joins(:members).where('sender_id = ? OR ( members.id = ? AND approver_id IS NOT NULL )',
                          member.id, member.id).uniq
  }

  alias_attribute :text, :message

  validates_presence_of :subject, :message

  def approved?
    !approver.nil?
  end

  def sent?
    !sent_at.nil?
  end

  def delivered?
    !delivered_at.nil?
  end

  def formatted_text(format = nil)
    markdown message, format
  end

  def date
    created_at.strftime('%m/%d/%Y')
  end

  def time_stamp(column = :delivered, format_type = :short)
    column = column.to_s + '_at'
    if self.respond_to?(column) and !self.send(column).nil?
      format = format_type.to_sym == :short ? '%m/%d/%Y %I:%M:%S %p' : '%A%n%B %e, %Y%nat %I:%M:%S %p'
      self.send(column).strftime(format)
    else
      'N/A'
    end
  end

  def status_class
    return 'status-red'    if !approved?
    return 'status-yellow' if !delivered?
    'status-green'
  end

  private

  def check_and_add_members
    self.members = Member.company_members.to_a.uniq if self.members.empty?
  end

end
