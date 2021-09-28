#include PDFGen.ahk

Document := new PDFGen.Document("AutoHotkey"
    , "MCLib & pdfgen"
    , "Example PDF"
    , "CloakerSmoker"
    , "Creating PDF files from AutoHotkey using a C library"
    , "2021-06-26"
    , PDFGen.A4Width, PDFGen.A4Height)

Page := Document.AddPage()

TextWidth := Document.GetTextWidth("Header here!", 24, "Times-Roman")
TextCentered := Document.HorizontalCenter(TextWidth)
Page.AddWrappedText("Header here!", TextCentered, 800,,, 24)

Page.AddLine(25, 750, PDFGen.A4Width - 25, 750)

ImageCentered := Document.HorizontalCenter(300)
Page.AddImageFile(ImageCentered, 400, 300, 300, "Image.bmp")

TextWidth := Document.GetTextWidth("And it was made by AHK", 12, "Times-Roman")
TextCentered := Document.HorizontalCenter(TextWidth)
Page.AddWrappedText("And it was made by AHK", TextCentered, 260,,, 12)

TextWidth := Document.GetTextWidth("How sad.", 10, "Times-Roman")
TextCentered := Document.HorizontalCenter(TextWidth)
Page.AddWrappedText("How sad.", TextCentered, 250,,, 10)

Document.SaveToFile("New.pdf")

MsgBox, % "Done"