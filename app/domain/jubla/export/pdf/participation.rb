# encoding: utf-8

#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Export::Pdf
  module Participation
    class EventDetails < Export::Pdf::Participation::EventDetails
      def render
        super
        render_condition if condition?
      end

      private

      def render_condition
        with_count(Event::Course::Condition.model_name.human) do
          text event.condition.content
        end
      end

      def condition?
        course? && event.condition.present?
      end
    end

    class Header < Export::Pdf::Participation::Header
      def image_path
        Wagons.find('jubla').root.join('app/assets/images/logo_jubla.png')
      end
    end

    class Runner < Export::Pdf::Participation::Runner
      Export::Pdf::Participation::Runner.stroke_bounds = true

      def sections
        [Header,
         Export::Pdf::Participation::PersonAndEvent,
         Export::Pdf::Participation::Specifics,
         Export::Pdf::Participation::Confirmation,
         EventDetails]
      end
    end

  end
end
