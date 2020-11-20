---
title: Accessing Nest Thermostat with Go
date: "2020-11-17T08:13:00.000Z"
description: Accessing Nest Thermostat with Go
---

I found accessing the data from my Nest Thermostat a little over-complicated.
There were many pages of documentation required to get things going. Also the
examples provided on the official SDK does a lot to obfuscate the important
points.

Here you will see the minimal set up to get humidity from your thermostat. Once
you have that, making assumptions about the SDK and navigating the documentation
will hopefully be a little easier!

## Prerequisites

- A Google account
- Access to the [developer console][0]
- [Golang installed][1]

## Here Goes

### Create Google Developer Project

Go to the [Google developer console][0] and create a new project.

Enable Smart Device Management [here][4] (I cannot figure out how to get there
with buttons right now)

Once complete click on **OAuth consent screen** in the left-hand navigation
and then **EDIT APP**.

- Page 1: Fill out the required fields
- Page 2: Click **ADD OR REMOVE SCOPES** and select all of the **Smart Device
  Management API** scopes.
- Page 3 & 4: Continue until complete

After finishing the form, click on the new client to edit it again. This time
there is a page with the client ID and client secret. At this point you should
also add `localhost:8080` to the Authorised Redirect URLs.

### Create Nest Project

First of all you need to go to the [device access][2] page and pay your \$5
one-time access fee.

Once that is processed head to the device access [project page][3] and click
**Create project**. At the time of writing there is a short series of pages,
fill them out like so:

1. **Name** - give your project a name (it can be renamed)
2. **OAuth client ID** - enter the OAuth client ID from your Google project
3. **Events** - disable (beyond scope of this piece)

### Time to Code

#### OAuth 2 Flow

First of all set up the OAuth config.

```go
conf := &oauth2.Config{
    ClientID:     clientId,
    ClientSecret: clientSecret,
    RedirectURL:  "http://localhost:8080",
    Scopes: []string{
        smartdevicemanagement.SdmServiceScope,
    },
    Endpoint: oauth2.Endpoint{
        AuthURL:  fmt.Sprintf("https://nestservices.google.com/partnerconnections/%s/auth", projectID),
        TokenURL: google.Endpoint.TokenURL,
    },
}
```

- Client ID and Secret are from the Google Developer Project
- Project ID is the Nest project, not the Google project
- localhost:8080 is acceptable, this will need setting in the OAuth client config page you created earlier

Next you need a token.

This code will get you a token to use in the HTTP client that will be
passed into the Smart Device Management service constructor.

```go
func authenticate(ctx context.Context, config *oauth2.Config) *oauth2.Token {
    log.Print("Your browser will be opened to authenticate with Google")
    log.Print("Hit enter to confirm and continue")

    url := config.AuthCodeURL("state", oauth2.AccessTypeOffline)

    codeChannel := make(chan string)
    mux := http.NewServeMux()
    server := http.Server{Addr: ":8080", Handler: mux}
    mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("<p style=font-size:xx-large;text-align:center>return to your terminal</p>"))

        codeChannel <- r.URL.Query().Get("code")
    })

    openBrowser(url)

    go func() {
        if err := server.ListenAndServe(); err != nil && err != http.ErrServerClosed {
            log.Fatal(err)
        }
    }()

    code := <-codeChannel

    log.Print("Shutting down server")

    server.Shutdown(context.Background())

    log.Print("Exchanging token")

    token, err := config.Exchange(ctx, code)
    if err != nil {
        log.Fatal(err)
    }

    return token
}
```

- I used [this `openbrowser()` function][5]. Does the job.
- A web server is set up to handle the redirect. Once it's job is done, the
  server is shut down.
- After `config.Exchange(ctx, code)` you should cache this and use it in future
  instead of using the web flow every time.
- Later on you will do a much, much better job of this function.

#### Creating the SDM Service

The service will be used to retrieve data from Google's Nest APIs.
Here the code snippets above will be put together into something
that should work...

```go
ctx := context.Background()
token := authenticate(ctx, conf)
httpClient := config.Client(ctx, token)
sdmService, err := smartdevicemanagement.NewService(ctx, option.WithHTTPClient(httpClient))
```

#### Time to GET Data

```go
devicesListResponse, err := sdmService.Enterprises.Devices.List(fmt.Sprintf("enterprises/%s", projectID)).Do()
if err != nil {
    log.Fatal(err)
}

for _, device := range devicesListResponse.Devices {

    m := make(map[string]interface{})
    err := json.Unmarshal(device.Traits, &m)
    if err != nil {
        log.Fatal(err)
    }

    var nestTraits Traits
    err = json.Unmarshal(device.Traits, &nestTraits)
    if err != nil {
        log.Fatal(err)
    }
    log.Printf("Temperature: %v", nestTraits.Temperature.Celcius)
    log.Printf("Humidity: %v%%", nestTraits.Humidity.Percent)
}
```

## Done

Good luck. As always, contact me via email or drop a PR on GitHub with any
suggestions or corrections. Happy to receive.

My application still has a bit of work to do. I am looking forward to keeping a
personal copy of all my thermostat data.

Cheers BYYYYYEEEEEEE

[0]: https://console.developers.google.com/
[1]: https://golang.org/doc/install
[2]: https://developers.google.com/nest/device-access
[3]: https://console.nest.google.com/device-access/project-list
[4]: https://console.developers.google.com/projectselector2/apis/library/smartdevicemanagement.googleapis.com
[5]: https://gist.github.com/hyg/9c4afcd91fe24316cbf0#file-gistfile1-txt
