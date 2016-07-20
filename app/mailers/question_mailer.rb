class QuestionMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email
  end

  def update(user, question)
    @question = question
    mail to: user.email, subject: t('question_mailer.update.subject', question_title: question.title)
  end
end
