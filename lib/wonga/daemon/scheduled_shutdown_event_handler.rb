module Wonga
  module Daemon
    class ScheduledShutdownEventHandler
      def initialize(api_client, logger)
        @api_client = api_client
        @logger = logger
      end

      def run
        ids = @api_client.send_get_request('/api/ec2_instances/ready_for_shutdown')
        if ids.any?
          @logger.info("Instances ready for shut down are #{ids}")
          ids.each do |instance_id|
            @api_client.send_post_request("/api/ec2_instances/#{instance_id}/shut_down", {})
          end
        else
          @logger.info('No instances scheduled for shutdown')
        end
      end
    end
  end
end
