library(rvest)

## Create a subset of githubSearch that provides the information needed

df <- githubSearch[ , c("name",
                        "owner.login",
                        "html_url",
                        "description",
                        "created_at",
                        "updated_at")]

df <- data.frame(df[ , c("name", "owner.login", "html_url")],
                 dashboard_url = vector(mode = "character", nrow(df)),
                 source = vector(mode = "character", nrow(df)),
                 df[ , c("description", "created_at", "updated_at")])

df <- tibble::tibble(df)

names(df) <- c("name", "developer", "github_url",
               "dashboard_url", "source", "description",
               "creation_date", "latest_update")

dashboards <- c("https://ncovtracker.doh.gov.ph/",
                "https://fassster.ehealth.ph/covid19/",
                "https://endcov.ph/",
                "https://datastudio.google.com/u/0/reporting/eca3cd78-5e5b-443a-98f2-b6e77e10a75e/page/L56MB?fbclid=IwAR0KAcae2Vns35zgZrBi7Vmtm8YUVrQpb_glksF6auldwaI8ybwNOGGrJWI",
                "https://datastudio.google.com/u/0/reporting/1A9hMs1SpiMr-2PqGeyFKsAenM0UVA5sL/page/5lpIB",
                "https://covid19ph.com/",
                "https://covid19.psphp.org/?page=tsr",
                "https://www.stompcovidph.com",
                "https://covid19stats.ph",
                "https://covidph.info/overview",
                "https://bantaycovid.com",
                "https://phcovidstatus.netlify.app",
                "https://www.facebook.com/gmanews/videos/vb.116724526976/282544262845838/?type=2&theater")

x <- data.frame(name = vector(mode = "character", length = length(dashboards)),
                developer = vector(mode = "character", length = length(dashboards)),
                github_url = vector(mode = "character", length = length(dashboards)),
                dashboard_url = dashboards,
                source = vector(mode = "character", length = length(dashboards)),
                description = vector(mode = "character", length = length(dashboards)),
                creation_date = vector(mode = "character", length = length(dashboards)),
                latest_update = vector(mode = "character", length = length(dashboards)))


df <- rbind(df, x)

github_url <- c("https://github.com/kimerran/covid19ph.net",
                "https://github.com/eflegara/COVID19PH-Projection",
                "https://github.com/covid19phunited/covid19phunited",
                "https://github.com/benhur07b/covid19-maps",
                "https://github.com/alexisrequerman/covid19ph",
                "https://github.com/chadgotis/Covid19ph",
                "https://github.com/covid19ph/covid19ph.github.io",
                "https://github.com/renatoivadriano/covid19phcasetracker",
                "https://github.com/shgkshimizu/covid19phstats",
                "https://github.com/igarren/covid19philippines",
                "https://github.com/bermylle/covid19PH_live",
                "https://github.com/rbrtbmnglg/_covid19phinfographics",
                "https://github.com/litemikx/covid19phresources")

dashboard_url <- c("https://covid19ph.net",
                   "https://covid19phunited.web.app/",
                   "https://bnhr.xyz/covid19-maps/",
                   "https://alexisrequerman.github.io/covid19ph/",
                   "https://github.com/leixdd/Covid19PH",
                   "https://chadgotis.github.io/Covid19ph/",
                   "https://covid19ph.github.io",
                   "https://renatoivadriano.github.io/covid19phcasetracker/index(original).html",
                   "https://shgkshimizu.github.io/covid19phstats/",
                   "https://covid19philippines.info",
                   "https://covid19ph-live.herokuapp.com",
                   "https://rbrtbmnglg.shinyapps.io/covid19ph-infographic/",
                   "http://www.covid19phresources.org")


z <- data.frame(github_url, dashboard_url)

df[df$github_url %in% z$github_url, "dashboard_url"] <- z$dashboard_url[z$github_url %in% df$github_url]

z <- data.frame(name = vector(mode = "character", length = length(dashboard_url)),
                developer = vector(mode = "character", length = length(dashboard_url)),
                github_url, dashboard_url,
                source = vector(mode = "character", length = length(dashboards)),
                description = vector(mode = "character", length = length(dashboards)),
                creation_date = vector(mode = "character", length = length(dashboards)),
                latest_update = vector(mode = "character", length = length(dashboards)))


df <- rbind(df, z)

dashboards <- df


## Scrape info from dashboards

xx <- ifelse(dashboards$dashboard_url == "", dashboards$github_url, dashboards$dashboard_url)

yy <- lapply(X = xx, FUN = xml2::read_html)

title <- lapply(X = yy, FUN = rvest::html_node, css = "title")
title <- lapply(X = title, FUN = rvest::html_text)
title <- unlist(title)




usethis::use_data(dashboards, overwrite = TRUE, compress = "xz")






