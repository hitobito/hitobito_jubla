# frozen_string_literal: true

class RemoveOutdatedCustomContents < ActiveRecord::Migration[7.0]
  def up
    custom_content_id = select_value("SELECT id FROM custom_contents WHERE key = 'new_member'")

    if custom_content_id.blank?
      say "CustomContent 'new_member' not found, moving on."
      return
    end

    execute("DELETE FROM custom_content_translations WHERE custom_content_id = #{custom_content_id};")
    execute("DELETE FROM custom_contents WHERE id = #{custom_content_id};")
  end

  def down
    CustomContent.seed_once(:key,
      {
        key: "new_member",
        placeholders_required: "recipient-name, recipient-profile-url"
      })

    CustomContent::Translation.seed_once(:custom_content_id, :locale,
      {
        custom_content_id: CustomContent.where(key: "new_member").first.id,
        locale: "de",
        label: "Ehemalige: Benachrichtigung",
        subject: "Danke für deinen Einsatz bei der Jubla!",
        body: "Liebe/Lieber {recipient-name}<br/><br/>Herzlichen Dank für dein wichtiges Engagement für Jungwacht Blauring. Bestimmt hast du viele tolle Erlebnisse gehabt und gute Freundschaften aufgebaut – eben Lebensfreu(n)de.<br/><br/> \"Freude und Freunde – und das fürs Leben\" soll auch heissen, dass deine Jubla-Zeit jetzt nicht vorbei sein muss. Als frischgebackene Ehemalige / frischgebackener Ehemaliger bist du nämlich ein wichtiger Teil für Jungwacht Blauring. Vielleicht braucht deine ehemalige Schar jedes Jahr tatkräftige Unterstützung beim Sommerlager-Aufbau? Oder der entsprechende Kantonalverband ist auf der Suche nach Leuten, die beim kantonalen Geländespiel die Verpflegung organisieren? Es wäre doch toll, wenn du auf diese oder andere Arten noch mit Jungwacht Blauring in Verbindung bleiben könntest. Darum kannst du in deinem Profil auf der <a href=\"{recipient-profile-url}\">jubla.db</a> bestimmen, welche Ebene dich in Zukunft kontaktieren und dir Informationen senden darf. Vielen Dank nochmals für dein Engagement – auch über deine aktive Zeit hinaus.<br/><br/>Liebe Grüsse<br/>Jungwacht Blauring Schweiz"
      })
  end
end
