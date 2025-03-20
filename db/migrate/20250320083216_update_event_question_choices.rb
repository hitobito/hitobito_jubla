class UpdateEventQuestionChoices < ActiveRecord::Migration[7.1]
  def change
    execute <<~SQL.squish
      UPDATE event_question_translations
SET
    choices = 'habe ich bereits und nehme ihn mit in den Kurs, leihe ich von jmd aus und nehme ihn mit in den Kurs (je neuer die Auflage desto besser), habe ich nicht/leihe ich nicht aus: bestelle ich hiermit als Ordner (Kosten: CHF 27.-)'
FROM
    event_questions
WHERE event_question_translations.event_question_id = event_questions.id
    AND event_questions.event_id IS NULL
    AND event_question_translations.question = 'Den schub (Ordner mit fünf schub-Broschüren, digital unter jubla.ch/schub)...'

    SQL
  end
end
