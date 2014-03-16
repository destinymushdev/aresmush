module AresMUSH
  module Login
    class ConnectCmd
      include AresMUSH::Plugin

      attr_accessor :charname, :password
      
      # Validators
      no_switches
      
      def want_command?(client, cmd)
         cmd.root_is?("connect")
      end
      
      def crack!
        cmd.crack!(/(?<name>[^\=]+)\=(?<password>.+)/)
        self.charname = trim_input(cmd.args.name)
        self.password = cmd.args.password
      end
      
      def validate_not_already_logged_in
        return t("login.already_logged_in") if client.logged_in?
        return nil
      end
      
      def validate_name_and_password
        return t('dispatcher.invalid_syntax', :command => 'connect') if (charname.nil? || password.nil?)
        return nil
      end

      def handle
        char = Character.find_by_name(charname)
        
        if (char.nil?)
          client.emit_failure(t("db.no_char_found"))
          return
        end
        
        if (!char.compare_password(password))
          client.emit_failure(t('login.password_incorrect'))
          return 
        end

        client.char = char
        Global.dispatcher.on_event(:char_connected, :client => client)
      end
      
      def log_command
        # Don't log full command for password privacy
        Global.logger.debug("#{self.class.name} #{client}")
      end
    end
  end
end
