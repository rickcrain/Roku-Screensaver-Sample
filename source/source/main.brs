Sub RunScreenSaver()    
    screen = CreateObject("roSGScreen")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)

    m.global = screen.GetGlobalNode()

    ' Creates (Global) variable currentColor
    m.global.AddField("currentColor", "int", true)
    m.global.currentColor = 0
    
    ' Creates (Global) variable colors
    m.global.AddFields({colors: []})
    ' Set colors array from Azure function return

    m.global.colors = PopulateData()

    ' Creates scene ColorSample
    scene = screen.CreateScene("ColorSample")
    screen.Show()
    
    ' Message Port that fires every 5 seconds to change value of currentColor if the screen isn't closed
    while(true) 
        msg = wait(5000, port)
        if (msg <> invalid)
            msgType = type(msg)
            if msgType = "roSGScreenEvent"
                if msg.IsScreenClosed() then return
            end if
        else
            m.global.currentColor += 10
        end if
    end while
End Sub

Function PopulateData() as object
    functionURL = "https://tk-screensaver-func.azurewebsites.net/api/GetColorSample?code=oTqFzakvXAA1d1IqW8BH95chmAiG3FT/zXv084j219U6TUSALha86Q=="
    
    request = Substitute("{0}&name={1}", functionURL, "Rick")

    json = RetrieveJSON(request)

    return json
End Function

Function RetrieveJSON(functionURL as string) as object
    xfer = CreateObject("roUrlTransfer")
    xfer.SetCertificatesFile("common:/certs/ca-bundle.crt")
    xfer.SetUrl(functionURL)
    response = xfer.GetToString()

    if (response <> "") then
        ' data has been retrieved
        json = ParseJSON(response)
        
        if (json <> invalid) then
            ' valid json has been parsed
            return json.SampleColors
        else
            'invalid json data.  Return an empty array.
            return []
        end if
    else
        ' data could not be retrieved.  Return an empty array.
        return []
    end if
End Function
