' Sub that changes the color name to the next color in the m.colors array
Sub ChangeColor()
    if (m.colorCount = (m.global.colors.Count() - 1))
        m.colorCount = -1
    end if
    m.colorCount += 1

    SetColorName(m.colorCount)
End Sub

Sub SetColorName(colorID as integer)
    ' Verify data exists
    if (m.global.colors.Count() > 0) then
        m.colorName.Text = Substitute("Hi {0}!" + chr(10) + chr(10) + "This color is {1}", m.global.colors[colorID].personName, m.global.colors[colorID].colorName)
        m.backgroundColor.Color = m.global.colors[colorID].colorValue
    else
        m.colorName.Text = "Cannot retrieve Screensaver data.  Please verify that your Roku is connected to the Internet."
        m.backgroundColor.Color = "0x000000"
    end if
End Sub

Sub init()
    ' Sets pointer to Background Color node to adjust fields
    m.backgroundColor = m.top.FindNode("backgroundColor")

    ' Sets pointer to Color Name node to adjust fields
    m.colorName = m.top.FindNode("colorName")
    m.colorName.font.size=36

    ' Initialize count
    m.colorCount = 0

    ' Sets colorName to first data record
    SetColorName(0)

    ' Field Observer that calls ChangeColor() function every time the value of currentColor is changed
    m.global.ObserveField("currentColor", "ChangeColor")
End Sub
