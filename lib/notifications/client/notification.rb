module Notifications
  class Client
    class Notification
      FIELDS = [
        :id,
        :reference,
        :email_address,
        :phone_number,
        :line_1,
        :line_2,
        :line_3,
        :line_4,
        :line_5,
        :line_6,
        :postcode,
        :type,
        :status,
        :template,
        :sent_at,
        :created_at,
        :completed_at
      ].freeze

      attr_reader(*FIELDS)

      def initialize(notification)

        FIELDS.each do |field|
            instance_variable_set(:"@#{field}", notification.fetch(field.to_s, nil)
            )
        end
      end

      [
        :sent_at,
        :created_at,
        :completed_at
      ].each do |field|
        define_method field do
          begin
            value = instance_variable_get(:"@#{field}")
            Time.parse value
          rescue
            value
          end
        end
      end

    end
  end
end
