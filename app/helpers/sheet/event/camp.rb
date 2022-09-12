module Sheet
  class Event
    class Camp < Sheet::Base

      def left_nav?
        true
      end

      def render_left_nav
        view.render "nav_left_#{view.nav_left}"
      end
    end
  end
end
