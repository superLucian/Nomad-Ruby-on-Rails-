class HomeController < ApplicationController

  def index
    if current_user && current_user.is_a?(User)
      redirect_to dashboard_path
    end
  end

  def faq
  end

  def about_us
  end

  def support
  end

  def how_it_works
  end

  def partners
  end

  def jobs
  end


  def student_loans
  end

  def student_loan_refinancing
  end

  def insurance
  end

  def health_insurance
  end

  def travelers_insurance
  end

  def renters_insurance
  end

  def auto_loans
  end

  def personal_loans
  end

  def credit_cards
  end

  def ofx
  end

  def terms
  end

  def contact_us
  end

  def contact_messages
    cm = ContactMessage.new
    ContactMessage.column_names.each do |col|
      cm.send("#{col}=",params[col])
    end
    cm.save
    UserMailer.contact_message(cm).deliver
    flash[:notice] = "Message sent! We'll be in touch."
    redirect_to "/contact-us?event=messageSent"
  end

  def privacy
    respond_to do |format|
      format.html
      format.pdf { render :pdf => "privacy.pdf" }
    end
  end

  def jobs_pdf
    respond_to do |format|
      format.html
      format.pdf { render :pdf => "jobs_pdf.pdf" }
    end
  end

  def sitemap
    respond_to { |format| format.xml { render 'home/sitemap.xml', layout: false} }
  end

  def video_sitemap
    respond_to { |format| format.xml { render 'home/video_sitemap.xml', layout: false} }
  end

  def blog_sitemap
    respond_to { |format| format.xml { render 'home/blog_sitemap.xml', layout: false} }
  end

  private

end