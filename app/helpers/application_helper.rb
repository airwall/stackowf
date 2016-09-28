module ApplicationHelper
  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end
  end

  def markdown(content)
    renderer = HTMLwithPygments.new(hard_wrap: true, filter_html: true)
    options  = {
      autolink:   true,
      no_intra_emphasis: true,
      disable_indented_code_blocks: true,
      fenced_code_blocks: true,
      lax_html_blocks: true,
      strikethrough: true,
      superscript: true
    }
    Redcarpet::Markdown.new(renderer, options).render(content).html_safe
  end

  def show_username(assign)
    assign.user.try(:username) || "%username%"
  end

  def show_link?(object)
    user_signed_in? && current_user.author_of?(object)
  end

  def login_options
    @redirect_path ? { redirect_to: request.path } : {}
  end

  def count_posts(question)
    count = question.answers.count
    count < 10 ? "#{count} Post" : "#{count} Posts"
  end

  def question_solved?(question)
    question.answers.where(best: true).exists?
  end

  def show_user_status(user)
    user.admin? ? "admin" : "member"
  end

  def set_body_content_block(answer, question)
    border = answer.best? ? "best-border" : ""
    background = answer.user.author_of?(question) ? "author" : ""
    "#{border} #{background}"
  end
end
