class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
    devise :database_authenticatable, :registerable, :validatable
    enum :role, { user: "user", moderator: "moderator", admin: "admin" }

    belongs_to :department, optional: true
    has_many :issues, dependent: :nullify # In case hard delete is ever perfored by admin
    has_many :votes, dependent: :delete_all
    has_many :issue_updates, dependent: :nullify # In case hard delete is ever perfored by admin

    validates :department_id, presence: true, if: :moderator?
    validates :department_id, absence: true, if: :user?
    validates :email, uniqueness: { conditions: -> { where(deleted_at: nil) } }

    scope :kept, -> { where(deleted_at: nil) }
    scope :discarded, -> { where.not(deleted_at: nil) }

    def discarded?
        deleted_at.present?
    end

    def discard!
        update!(deleted_at: Time.current)
    end

    def undiscard!
        update!(deleted_at: nil)
    end

    # Block soft-deleted account from authentication
    def active_for_authentication?
        super && !discarded?
    end

    def inactive_message
        discarded? ? :deleted_account : super
    end
end
