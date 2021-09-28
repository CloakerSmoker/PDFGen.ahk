# PDFGen.ahk

An example library built using [MCL](https://github.com/G33kDude/MCL.ahk) and an existing C library.

The actual work to build PDF files is being done by the wonderful [PDFGen](https://github.com/AndreRenaud/PDFGen) C library by Andre Renaud. 

The library was slightly modified to not include a few headers which MCL either doesn't implement, or implements in a non-standard way. Besides that, PDFGen is unchanged, with a thin wrapper provided by `PDFGenToAHK.c` which is the actual file compiled by MCL.

Now, the fun part:

## API

The `PDFGen.Document` class represents a single PDF document, and can be instantiated to start building a new PDF.

The constructor of `PDFGen.Document` takes the following parameters:
```
__New(Creator, Producer, Title, Author, Subject, Date, Width, Height)
```

Where all but `Width` and `Height` are strings. `Width`/`Height` are floats, and can be manually specified. However, it is recommended to use `PDFGen.A4Width` and `PDFGen.A4Height` (mainly because I never tested any other values and this is a proof of concept).

---

Once you've got a `PDFGen.Document` built, you need to add a page to the document before you can add any content. This is done by the `Document.AddPage()` method, which will return a new `PDFGen.Page` object bound to the parent document.

From there, the following methods can be used to add content to the page:

* `Page.AddText(Text, X, Y, Size := 12, Color := 0)`
* `Page.AddWrappedText(Text, X, Y, WrapWidth := 400, Align := 0, Size := 12, Color := 0)`
* `Page.AddLine(X1, Y1, X2, Y2, Width := 3, Color := 0)`
* `Page.AddImageData(X, Y, DisplayWidth, DisplayHeight, pData, Size)`
* `Page.AddImageFile(X, Y, DisplayWidth, DisplayHeight, FilePath)`

---

When adding images, the following formats are supported:

* PPM/PGM
* JPEG
* PNG (without transparency)
* BMP

---

To center items (horizontally, I didn't do the math for vertically), the following `Document` methods can be used:

* `Document.GetTextWidth(Text, Size := 12)` returns width of the text at `Size`/`Font` in pixels
* `Document.HorizontalCenter(Width)` returns the X coordinate that an item `Width` pixels wide would need to be placed at to be centered on a page.

---

Finally, to save the PDF, the `Document.SaveToFile(Path)` method will write out your PDF file.