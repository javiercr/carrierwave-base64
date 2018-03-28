module Carrierwave
  module Base64
    module Adapter
      def mount_base64_uploader(attribute, uploader_class, options = {})
        mount_uploader attribute, uploader_class, options

        define_method "#{attribute}=" do |data|
          send "#{attribute}_will_change!" if data.present?

          return super(data) unless data.is_a?(String) &&
                                    data.strip.start_with?('data')

          filename = if options[:file_name].respond_to?(:call)
            options[:file_name].call(self)
          else
            options[:file_name]
          end.to_s

          super(Carrierwave::Base64::Base64StringIO.new(
            data.strip, filename || 'file'
          ))
        end
      end
    end
  end
end
