#Include %A_ScriptDir%/../../
#Include MCL.ahk

SetWorkingDir, % A_ScriptDir

class PDFGen {
    Load() {
        FileRead, Source, PDFGenToAHK.c

        for k, v in MCL.FromC(Source) {
            this[k] := v
        }

        DllCall(PDFGen.pdf_get_a4_dimensions, "Float*", A4Width, "Float*", A4Height)

        PDFGen.A4Width := A4Width
        PDFGen.A4Height := A4Height
    }

    static _ := PDFGen.Load()

    class Page {
        __New(pDocument, pPage) {
            this.pDocument := pDocument
            this.pPage := pPage
        }

        Resize(Width, Height) {
            return DllCall(PDFGen.pdf_page_set_size, "Ptr", this.pDocument, "Ptr", this.pPage
                , "Float", Width, "Float", Height)
        }

        AddText(Text, X, Y, Size := 12, Color := 0) {
            return DllCall(PDFGen.pdf_add_text, "Ptr", this.pDocument, "Ptr", this.pPage
                , "AStr", Text, "Float", Size
                , "Float", X, "Float", Y
                , "UInt", Color)
        }
        AddWrappedText(Text, X, Y, WrapWidth := 400, Align := 0, Size := 12, Color := 0) {
            return DllCall(PDFGen.pdf_add_text_wrap, "Ptr", this.pDocument, "Ptr", this.pPage
                , "AStr", Text, "Float", Size
                , "Float", X, "Float", Y
                , "UInt", Color
                , "Float", WrapWidth, "UInt", Align
                , "Ptr", 0)
        }
        AddLine(X1, Y1, X2, Y2, Width := 3, Color := 0) {
            return DllCall(PDFGen.pdf_add_line, "Ptr", this.pDocument, "Ptr", this.pPage
                , "Float", X1, "Float", Y1, "Float", X2, "Float", Y2
                , "Float", Width, "UInt", Color)
        }

        AddImageData(X, Y, DisplayWidth, DisplayHeight, pData, Size) {
            return DllCall(PDFGen.pdf_add_image_data, "Ptr", this.pDocument, "Ptr", this.pPage
                , "Float", X, "Float", Y, "Float", DisplayWidth, "Float", DisplayHeight
                , "Ptr", pData, "UInt64", Size)
        }

        AddImageFile(X, Y, DisplayWidth, DisplayHeight, FilePath) {
            return DllCall(PDFGen.pdf_add_image_file, "Ptr", this.pDocument, "Ptr", this.pPage
                , "Float", X, "Float", Y, "Float", DisplayWidth, "Float", DisplayHeight
                , "AStr", FilePath)
        }
    }

    class Document {
        __New(Creator, Producer, Title, Author, Subject, Date, Width, Height) {
            this.pDocument := DllCall(PDFGen.pdf_create_info
                , "AStr", Creator
                , "AStr", Producer
                , "AStr", Title
                , "AStr", Author
                , "AStr", Subject
                , "AStr", Date
                , "Float", Width, "Float", Height
                , "Ptr")
        }

        GetTextWidth(Text, Size := 12, Font := "Times-Roman") {
            DllCall(PDFGen.pdf_get_font_text_width, "Ptr", this.pDocument
                , "AStr", Font
                , "AStr", Text
                , "Float", Size
                , "Float*", Width)
            
            return Width
        }

        Width[] {
            get {
                return DllCall(PDFGen.pdf_width, "Ptr", this.pDocument, "Float")
            }
        }
        Height[] {
            get {
                return DllCall(PDFGen.pdf_height, "Ptr", this.pDocument, "Float")
            }
        }

        AddPage(Width := -1, Height := -1) {
            if (Width < 0 || Height < 0) {
                Width := this.Width
                Height := this.Height
            }

            pPage := DllCall(PDFGen.pdf_append_page, "Ptr", this.pDocument, "Ptr")

            return new PDFGen.Page(this.pDocument, pPage)
        }

        HorizontalCenter(ItemSize) {
            Middle := this.Width / 2.0
            HalfSize := ItemSize / 2.0

            return Middle - HalfSize
        }

        SaveToFile(FilePath) {
            DllCall(PDFGen.pdf_save, "Ptr", this.pDocument, "AStr", FilePath)
        }

        __Delete() {
            DllCall(PDFGen.pdf_destroy, "Ptr", this.pDocument)
        }
    }
}