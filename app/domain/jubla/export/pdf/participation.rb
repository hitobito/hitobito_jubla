#  Copyright (c) 2012-2013, Jungwacht Blauring Schweiz. This file is part of
#  hitobito and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito.

module Jubla::Export::Pdf
  module Participation
    # jubla_ci wagon is not present when running tarantula
    JUBLA_CI = Wagons.find("jubla_ci")

    class Header < Export::Pdf::Participation::Header
      def render_image
        if JUBLA_CI
          image_path = JUBLA_CI.root.join("app/assets/images/logo_jubla_plain.png")
          image image_path, at: [bounds.width - 60, cursor + 30], width: 60
        end
      end
    end

    class PersonAndEvent < Export::Pdf::Participation::PersonAndEvent
      class Person < Export::Pdf::Participation::PersonAndEvent::Person
        def render
          super
          labeled_attr(person, :originating_flock)
          labeled_attr(person, :originating_state)
          render_people_managers
        end

        def person_attributes
          super + [:j_s_number]
        end

        def address_details
          zip_code, town = super
          [zip_code, [town, person.canton].compact_blank.join(", ")]
        end

        def render_people_managers
          return unless person.people_managers.any?

          with_settings(font_size: 7) do
            move_down_line
            text PeopleManager.model_name.human(count: person.people_managers.count), style: :bold
            person.people_managers&.each do |manager|
              text "#{manager.manager}: #{[manager.email, manager.phone_number&.number].compact_blank.join(", ")}"
            end
          end
        end
      end

      self.person_section = Person
    end

    class Confirmation < Export::Pdf::Participation::Confirmation
      def render
        # Try to keep remarks and signatures together on the same page
        pdf.start_new_page if cursor < required_height
        super
        render_remarks if event.remarks?
      end

      private

      def render_remarks
        y = cursor

        with_settings(line_width: 0.9, fill_color: "cccccc") do
          fill_and_stroke_rectangle [0, y], bounds.width, 70
        end

        pdf.bounding_box([0 + 5, y - 5], width: bounds.width - 10, height: 65) do
          pdf.text_box(event.remarks, overflow: :shrink_to_fit)
        end
        move_down_line
      end

      def contact_address
        [contact.respond_to?(:company_name) && contact.company_name,
          contact.to_s,
          contact.address.present? && contact.address.split("\n"),
          "#{contact.zip_code} #{contact.town}".strip]
          .flatten
          .select { |v| v.present? }
          .join(", ")
      end

      def required_height
        line_height = 10
        height = 2.5.cm # page margin plus page numbering
        height += 2 * line_height if read_and_agreed?
        height += 3 * line_height if event.signature?
        height += 3 * line_height if signature_confirmation?
        height += 2 * line_height if contact
        height += 6.5 * line_height if event.remarks?
        height
      end

      def read_and_agreed?
        event.signature? || signature_confirmation?
      end
    end

    class EventDetails < Export::Pdf::Participation::EventDetails
      def render
        pdf.start_new_page if description? || requirements?
        super
        render_condition if condition?
      end

      private

      def render_condition
        with_header(Event::Course::Condition.model_name.human) do
          text event.condition.content.to_plain_text, inline_format: true
        end
      end

      def condition?
        course? && event.condition.present?
      end

      def requirements?
        requirements = [event.application_conditions]

        if course?
          requirements += [event_kind.minimum_age,
            event_kind.qualification_kinds("precondition", "participant")]
        end

        requirements.any?(&:present?)
      end

      def event_with_kind?
        super && !event.kind.is_a?(Event::Camp::Kind)
      end
    end

    class GeneralInformation < Export::Pdf::Participation::GeneralInformation
      private

      def event_with_kind?
        super && !event.kind.is_a?(Event::Camp::Kind)
      end
    end

    class Runner < Export::Pdf::Participation::Runner
      private

      def customize(pdf)
        if JUBLA_CI
          font_path = JUBLA_CI.root.join("app/assets/fonts")

          pdf.font_families.update("Century Gothic" => {
            normal: font_path.join("century-gothic.ttf"),
            bold: font_path.join("century-gothic-b.ttf"),
            italic: font_path.join("century-gothic-i.ttf"),
            bold_italic: font_path.join("century-gothic-b.ttf")
          })

          pdf.font "Century Gothic"
        end
        pdf.font_size 9
      end

      def sections
        [Header,
          PersonAndEvent,
          Export::Pdf::Participation::Specifics,
          Confirmation,
          EventDetails,
          GeneralInformation]
      end
    end
  end
end
