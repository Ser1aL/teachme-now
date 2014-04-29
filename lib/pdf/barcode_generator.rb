module BarcodeGenerator

  CODES_PATH = 'public/qr_codes'

  def generate_pdf_receipt(lesson, user)
    qr_code = generate_qr_svg(lesson, user)
    output_filename = "#{Time.now.to_f}.pdf"
    path_to_pdf = File.join(Rails.root, 'public', 'pdf_receipts', output_filename)
    html_haml_layout = File.read(File.join(Rails.root, 'lib', 'pdf', 'receipt.html.haml'))

    object = Object.new
    Haml::Engine.new(html_haml_layout).def_method(object, :render, :qr_code, :lesson, :user)
    html = object.render(qr_code: qr_code, lesson: lesson, user: user)

    PDFKit.new(html, :page_size => 'A4').to_pdf(path_to_pdf)
    path_to_pdf
  end

  def generate_qr_svg(lesson, user)
    qrcode = Barby::QrCode.new("TEACHME/#{lesson.id}#{(user.id.to_i * lesson.id.to_i) % 100 + user.id}/SECURED")
    file_path = CODES_PATH + '/' + lesson.id.to_s + '_' + user.id.to_s + '.svg'
    File.open(file_path, 'w'){ |qr_code_file| qr_code_file.puts qrcode.to_svg(height: 30, margin: 2) }
    file_path
  end

end
