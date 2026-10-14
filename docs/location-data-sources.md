# Lagaw — Bacolod City destination seed: source notes

**Research checked:** 2026-10-14 (Philippine local calendar date).  
**Purpose:** Research-only sample of 10 real places; this is **not** a live opening-status guarantee or a production-ready commercial directory.  
**Files:** `locations.json` (exactly the requested fields). No user, interaction, trip, itinerary, SQL, or application records are included.

## Method and provenance conventions

- **Sourced facts:** existence, venue type, location/address, source-published times and prices, and mapping coordinates. Each place below identifies supporting URLs.
- **Curated editorial values:** the `category` normalization, every `vibe_tags` value, every `suitable_group_types` label, and the original descriptions (paraphrases based on cited venue features). These are **not claims made by venues**.
- **Planning estimates:** all `typical_visit_duration` integers are **editorial estimates in minutes**—**none** is presented as a venue-published duration. They exclude travel and queue times. Do not use as published facts.
- **Unknowns:** `null` means not adequately corroborated, **not zero**. `{}` in `opening_hours` means unverified, **not 24-hour opening**. An omitted weekday is **unknown**, not closed. `is_active: true` means a plausible, not-known-permanently-closed seed candidate; it must not be interpreted as proof the destination is open today.
- **Costs:** Philippine pesos per visitor. Only the Negros Museum supplies sufficiently clear **required admission** prices; the range in JSON reflects **different eligibility classes**, **not** a price that every visitor may pay. Cafés/restaurants sell optional food and drinks, but no reliably dated price list was verified; `estimated_cost_min` and `estimated_cost_max` remain `null`. No site is assumed free. Optional food purchases are not admission charges.
- **Coordinates:** decimal latitude/longitude are copied **together** from exact-feature Mapcarta pages based on OpenStreetMap (OSM). For mapped areas/buildings these may be **feature centers, not entrances or routing drop-off points**. Coordinates absent from a verified exact-feature source are both `null`. Each such entry has the map URL and OSM feature ID below. Mapping pages occasionally display unrelated **Davao Region** text in their auto-generated administrative hierarchy while simultaneously identifying the destination as Bacolod; geographic membership is independently established via venue/government sources, not these extraneous hierarchy strings. Validate pins before live routing.
- **Images:** every `image_url` is `null`. Maps and websites may show photographs with photographer/license credits, but a displayed photo does not authorize reuse in Lagaw. No individual image was selected or licensed. Obtain a specific asset and verify attribution/license and any additional restrictions first.
- **Publication vs check dates:** check date is **2026-10-14** for links below; pages without a visible publication/update date are recorded as **undated**. A website footer's year (e.g. the Negros Museum's `© 2013`, Radisson `© 2026`) is **not** an article publication date or last review date.

### Starting sources and access constraints

1. Bacolod City Tourism Office, [About Us](https://tourism.bacolodcity.gov.ph/about.php) — **direct page could not be fetched** on 2026-10-14 (cache-miss/access error). Search indexing suggests historic landmarks, but **no JSON factual field relies solely on that preview**.
2. Bacolod City Tourism Office, [Accredited Directory](https://tourism.bacolodcity.gov.ph/accredited-directory.php) — **direct page could not be fetched** on 2026-10-14. The related [Accreditation Hub](https://tourism.bacolodcity.gov.ph/accreditation.php) likewise could not be fetched. An older city-hosted [DOT accredited tourism establishments PDF, as of Feb. 21, 2025](https://bacolodcity.gov.ph/wp-content/uploads/2025/03/DOT-Accredited-Tourism-Establishments-As-of-February-21-2025_compressed.pdf) also timed out. **No current accreditation claim is made.**
3. The Negros Museum (venue's own site), [Museum Hours](https://negrosmuseum.wixsite.com/negrosmuseum/museum-hours) — **successfully opened**; times, admission classes and Gatuslao Street address can be read directly. Publication/last-updated date **not stated**; footer `© 2013` is not a freshness signal.

## Location-by-location field provenance

### 1. San Sebastian Cathedral

- **Sources (checked 2026-10-14):** [Mapcarta, San Sebastian Cathedral](https://mapcarta.com/W53385500) (OSM-backed, undated); [Radisson Hotels, nearby attractions and cathedral](https://www.radissonhotels.com/en-us/hotels/park-inn-bacolod) (operator, undated); [Bacolod City Government, 2017–2026 land-use/zoning document](https://bacolodcity.gov.ph/wp-content/uploads/2023/03/02-CLUP-2017-2026-VOLUME-II-ZO.pdf) (planning document published online in 2023; entire PDF could not be fetched directly in this research environment).
- **Sourced populated fields:** `name`, Bacolod location, cathedral/heritage character, and address **Jose Rizal Street** from Mapcarta; historic coral-stone church from Radisson's attractions section; JSON `description` independently paraphrased. Mapped coordinates: **10.67035, 122.94715** from Mapcarta **OSM way 53385500** (cathedral feature).
- **Curated:** `category=heritage`; `vibe_tags=[heritage, photography]`; `suitable_group_types` as in JSON. **Planning estimate:** 25 minutes.
- **Hours / costs:** `opening_hours={}`; admission cost **unknown**. Worship service times are **not** visitor opening hours. Photography, interior admission and accessible times need direct confirmation.
- **Image:** no verified reusable file selected; `image_url=null`.
- **Conflicts/status:** no known permanent closure; active religious site according to published venue and mapping descriptions, but visitor-access arrangements unverified.

### 2. The Negros Museum

- **Sources (checked 2026-10-14):** [The Negros Museum, Museum Hours](https://negrosmuseum.wixsite.com/negrosmuseum/museum-hours) (venue publisher, **undated**; `© 2013` footer is not an update date); [The Negros Museum home page](https://negrosmuseum.wixsite.com/negrosmuseum) (venue, undated); [Mapcarta, The Negros Museum](https://mapcarta.com/W1239574893) (OSM-based mapping, undated).
- **Sourced populated fields:** `name`, museum purpose and **Gatuslao Street, Bacolod City** from official museum page. Mapcarta supports **10.67516, 122.95032**, **OSM way 1239574893**. Museum page explicitly publishes **Monday–Saturday 09:00–18:00**; **Sunday is not declared closed**, so it is **omitted**, not represented as `[]`.
- **Published required admissions (PHP):** adult **₱100**, senior **₱80**, student/child **₱70**. JSON `estimated_cost_min=70` and `estimated_cost_max=100` give the lowest and highest **published eligibility-specific admission**, not a uniformly available visitor price. Confirm eligibility criteria, discounts and 2026 prices before production.
- **Curated:** `category=museum`; `vibe_tags=[heritage, photography]`; editorial group labels. **Planning estimate:** 60 minutes.
- **Image:** null; a CC-licensed photograph appearing elsewhere was not chosen, so no individual image attribution is asserted.
- **Conflicts/status:** older undated official site gives **published**, not independently confirmed **current**, hours/fees. Confirm current operations, special schedules and holiday hours directly.

### 3. Negros Forest Park

- **Sources (checked 2026-10-14):** [Talarak Foundation, Negros Forest Park](https://www.talarak.org/negros-forest-park) (**operator, undated**); [Talarak Foundation, About](https://www.talarak.org/about) (operator, undated); [Mapcarta, Negros Forests and Ecological Foundation Biodiversity Conservation Center](https://mapcarta.com/W317092403) (OSM mapping of historic/predecessor name, undated).
- **Sourced populated fields:** operator explicitly says it manages Negros Forest Park, **South Capitol Road, Bacolod City**, and describes visitor-facing wildlife conservation. Mapcarta maps the park's historically labeled conservation center at **10.67507, 122.95105**, **OSM way 317092403**. Mapping **uses the former foundation name**; Talarak confirms the predecessor relationship, but confirm the route/entrance and present pin before production.
- **Curated:** `category=park` (a visitor-friendly normalization of conservation center, not a claim that it is a generic freely accessible park); `vibe_tags=[nature, photography]`; groups editorial. **Planning estimate:** 60 minutes.
- **Hours/prices:** unknown (`{}`/`null`). Some **third-party social-media mirrors** list a six-day schedule, but that was **not verified on Talarak's official site**; it was intentionally excluded. No admission fee was published in an accessible official page.
- **Image:** null.
- **Status:** Talarak explicitly describes the park as open to visitors; exact current times, bookings, fee changes and special conditions must be confirmed.

### 4. Orange Project

- **Sources (checked 2026-10-14):** [Orange Project, About](https://orangeproject.ph/about/) (official gallery website, undated); [Orange Project homepage](https://orangeproject.ph/) (official gallery, undated); [Orange Project exhibitions archive](https://orangeproject.ph/category/exhibitions/) (official, posts dated in **2026**, including July 3; these are exhibition-post dates, not sitewide updates). Exact-feature mapping page [Mapcarta, Orange Project](https://mapcarta.com/N13233981086) was **not fetchable when opened**; search/index listings exist but coordinates **not** imported.
- **Sourced populated fields:** named venue, art-gallery function, and **Orange Project Building, Art District, Lopue's Annex Building, Mandalagan, Bacolod City 6100** from official gallery site; current-ish activity supported by gallery's 2026 exhibition archive.
- **Curated:** `category=gallery` (allowed additional lowercase category), `vibe_tags=[photography, relaxing]` and groups editorial; **planning estimate 45 minutes**. `latitude` and `longitude` both null due source-fetch problem.
- **Hours/prices:** unknown. Mapping listings sometimes give **Mon–Sat 13:00–19:00; Sun 13:00–17:00**, but accessible official venue pages did not independently publish the schedule, so JSON hours remain `{}`. Exhibitions, appointments, openings and any ticket charges are not inferred.
- **Image:** null.
- **Status:** active exhibition publisher in 2026, but confirm admission rules and exhibition calendar.

### 5. Capitol Park and Lagoon

- **Sources (checked 2026-10-14):** [Provincial Government of Negros Occidental, 2020 reopening announcement](https://www.negros-occ.gov.ph/news/capitol-park-and-lagoon-opens-today/) (article originally dated **Nov. 7, 2020**); [Mapcarta, Capitol Park and Lagoon](https://mapcarta.com/W317092395) (OSM, undated); [Provincial government, Culture Hub Passport](https://www.negros-occ.gov.ph/news/pa-atty-rayfrando-diaz-introduces-the-cultural-hub-passport/) (**Nov. 4, 2021**).
- **Sourced populated fields:** name, **in Bacolod City**, public lagoon/park at the provincial capitol complex from provincial government, with Mapcarta feature at **10.67600, 122.95213**, **OSM way 317092395**. `address` gives the complex-level site rather than inventing a gate/street address.
- **Curated:** `category=park`, nature/relaxing/photography tags and groups editorial; **planning estimate 35 minutes**.
- **Hours/fees:** not established for 2026; `{}`/`null` remain. **Do not apply** the 2020 COVID-era visitor restrictions or 2020 reopening announcement as present-day policy/hours.
- **Image:** null.
- **Status:** 2020 reopening and subsequently promoted public attraction, but check any current restrictions or event closures.

### 6. Negros Occidental Provincial Capitol

- **Sources (checked 2026-10-14):** [Provincial Government of Negros Occidental, Contact Us](https://www.negros-occ.gov.ph/contact-us/) (undated governmental contact page); [Mapcarta, Negros Occidental Provincial Capitol](https://mapcarta.com/W317092375) (OSM, undated); [Provincial Government Culture Hub](https://www.negros-occ.gov.ph/culture-hub/) (undated). 
- **Sourced populated fields:** government publisher explicitly gives **Provincial Capitol Building, Gatuslao Street, Bacolod City**; map feature for the building at **10.67647, 122.95093**, **OSM way 317092375**. Original description paraphrases government and mapping character.
- **Curated:** `category=landmark`, `[heritage, photography]` and groups editorial; **planning estimate 20 minutes** for exterior appreciation, **not** a guided government-building tour.
- **Hours/fees:** not established for **tourist access**, `{}`/`null`. Government website's contact-footer office hours (Tuesday–Friday **08:00–19:00**) are **not public sightseeing hours** and are deliberately not copied.
- **Image:** null.
- **Status:** functioning government offices, but **interior access, photography and tours** need official confirmation.

### 7. Cafetolyo Coffee Shop

- **Sources (checked 2026-10-14):** [Provincial Government, Culture Hub Passport](https://www.negros-occ.gov.ph/news/pa-atty-rayfrando-diaz-introduces-the-cultural-hub-passport/) (official article dated **Nov. 4, 2021**, successfully opened); [Provincial Government, Cafetolyo Coffee Shop Reopens](https://www.negros-occ.gov.ph/news/%F0%9D%90%82%F0%9D%90%9A%F0%9D%90%9F%F0%9D%90%9E%F0%9D%90%AD%F0%9D%90%A8%F0%9D%90%A5%F0%9D%90%B2%F0%9D%90%A8-%F0%9D%90%82%F0%9D%90%A8%F0%9D%90%9F%F0%9D%90%9F%F0%9D%90%9E%F0%9D%90%9E-%F0%9D%90%92/) (government result indexed as **Feb. 13, 2026**, **direct article did not load**; official indexed text describes reopening with coffee/snacks).
- **Sourced populated fields:** government 2021 Culture Hub circuit names Cafetolyo within **provincial capitol vicinity, Bacolod City**; the February 2026 government article search record identifies it specifically at the Capitol Park and Lagoon. The exact street-number entrance **is not verified**, and coordinates are both null.
- **Curated:** `category=cafe`, `vibe_tags=[cafe, food, relaxing]`, groups editorial; **planning estimate 35 minutes**.
- **Hours / price:** **unknown**. The 2026 source calls drinks and pastries affordable, **not** a numerical menu-price publication; both costs null (any purchases optional).
- **Image:** null.
- **Status/conflict:** a 2026 reopening announcement is discoverable via a government-indexed record but its complete page **was inaccessible** at research time. The older primary article supports existence/location; **call/visit to confirm still operating** before production. Do not silently mark it as presently open.

### 8. Arima Restaurant

- **Sources (checked 2026-10-14):** [Radisson Hotels, Arima Restaurant](https://www.radissonhotels.com/en-us/hotels/park-inn-bacolod/restaurants-and-bars/arima-restaurant) (official operator page, **undated**); [Radisson Hotels, Park Inn by Radisson Bacolod](https://www.radissonhotels.com/en-us/hotels/park-inn-bacolod) (official operator, **undated**).
- **Sourced populated fields:** restaurant name and regional/international all-day dining from Arima venue page; hotel site confirms the Bacolod address at **Block 12 Reclamation Area, Palanca Avenue, SM City Bacolod Complex**. The operator publishes **daily 06:00–22:00 all-day dining** (JSON covers all seven days). It also separately publishes **breakfast weekdays 06:00–10:00**, **weekends/public holidays 06:00–11:00**—this is a **service sub-schedule, not a second general-opening interval**, so it is documented here, not duplicated in the JSON opening-hour arrays.
- **Curated:** `category=restaurant`, `[food, relaxing]` and groups editorial; **planning estimate 75 minutes**.
- **Cost:** no dated all-day menu price range verified; food purchases are optional but restaurant dining requires purchasing food in practice. Null is **not** free dining. **Coordinates null:** no exact venue-specific decimal pair verified.
- **Image:** null.
- **Status:** official live venue site, but confirm seasonal menus, reservations and holiday exceptions.

### 9. Panaad Park and Sports Complex

- **Sources (checked 2026-10-14):** [Bacolod City Government, 29th Panaad Festival officially opens](https://bacolodcity.gov.ph/29th-panaad-sa-negros-festival-officially-opens/) (official city report, **Mar. 25, 2025**; successfully opened); [Philippine News Agency, Panaad sports complex upgrade](https://www.pna.gov.ph/articles/1207316) (**Aug. 7, 2023**, government news agency); [Mapcarta, Panaad Park and Sports Complex](https://mapcarta.com/W511762150) (OSM, undated). 2026 news on Panaad activities appears in indexed government pages, but some exact article pages failed to fetch.
- **Sourced populated fields:** Bacolod city report places venue in **Barangay Mansilingan, Bacolod City** and confirms festival use. Mapcarta provides park feature at **10.62379, 122.96481**, **OSM way 511762150** (park centroid, not necessarily stadium gate).
- **Curated:** `category=park`, `[nature, photography]`, groups editorial; **planning estimate 60 minutes** under accessible ordinary-day circumstances.
- **Hours/prices:** unknown; **event access does not establish daily access**. Fees, schedules and accessibility of specific facilities, sports events and festival pavilions require confirmation.
- **Image:** null.
- **Status:** not known permanently closed, but **ordinary-day park access is uncertain**; verify with the provincial park operator before shipping.

### 10. Calea Pastries & Coffee

- **Sources (checked 2026-10-14):** [Apple Maps, Calea Pastries & Coffee](https://maps.apple.com/place?place-id=I8D5737486424C8CB) (mapping listing, **undated**); [bacolod.com, Cafés & Desserts](https://bacolod.com/explore?category=cafes-desserts) (local visitor guide, **undated**); [The List, Bacolod coffee shops](https://www.thelist.ph/top-coffee-shops-bacolod/) (travel guide article, **older; search result publication age about 3 years**). **No independently authenticated official Calea website or business-owned page was confirmed.** A Calea-themed website on an unrelated Vercel domain was **not treated as official**.
- **Sourced populated fields:** Apple Maps listing identifies **Calea Pastries & Coffee**, type bakery and **15th Street, Bacolod City, Negros Occidental**; local visitor guide supports cakes/coffee in Bacolod. Coordinate pair **not verified**, both null.
- **Published/listed hours conflict:** Apple Maps says **Sun–Thu 09:00–21:30; Fri–Sat 09:00–22:00**. The older travel-guide listing gives a different pattern (**Sun–Thu 10:00–21:00; Fri–Sat 10:00–19:00**). **Neither is an authenticated present-day venue publication**. Because these disagree and no current operator confirmation exists, `opening_hours={}` deliberately retains uncertainty.
- **Curated:** `category=cafe`, `[cafe, food, relaxing]` and groups editorial; **planning estimate 40 minutes**.
- **Prices:** unknown, optional pastries/coffee purchases; not `0`.
- **Image:** null.
- **Status:** Apple Maps and a local guide list the venue, but **current opening and business status require direct confirmation** before production.

## Data quality and conflict register

| Issue | Handling | Manual follow-up |
| --- | --- | --- |
| Tourism Office About and Accredited Directory could not be opened | No claims depend solely on their snippets; accreditation unverified | Open pages from campus internet, capture date and venue status |
| Negros Museum official page has old `© 2013` footer and no last-update date | Hours and admission are reported as *published*, not necessarily current | Confirm Monday–Saturday schedule, Sunday policy, 2026 ticket rates and holidays |
| Calea hours disagree between Apple Maps and an older travel guide | Set JSON `opening_hours={}` | Ask venue/verify official business listing |
| Negros Forest Mapcarta/OSM label retains former managing-organization name | Coordinates attached to the historically labeled conservation-center feature; no assumed entrance | Verify current park boundary and gate in person |
| Mapping auto-generated location strings contain irrelevant Davao-area fragments | Use municipality from venue/government sources, not autogenerated breadcrumb | Check OSM metadata and exact pin placement |
| Orange Project mapped-page fetch failed | No lat/lon imported | Verify gallery-specific coordinate pair |
| Cafetolyo 2026 reopening article direct page failed | 2021 official article + 2026 search-index text; current status unconfirmed | Contact operator and re-fetch complete 2026 article |
| Capitol Park COVID-era limitations dated 2020 | Do not apply historical visitor restrictions | Confirm current access and any city-event restrictions |
| Panaad festival access vs ordinary-day park access | Keep general hours and entry costs unknown | Confirm park gate hours, festival-day vs ordinary access, facilities and fees |
| Venue/stock/public photos have no verified reuse clearance | All image URLs null | Obtain permission or specific CC-licensed assets with credit tracking |

## Production verification checklist

1. **Visitor operations:** actual 2026 operating status and access for every place, especially Negros Museum, Cafetolyo, Calea, Panaad and potentially restricted heritage/civic interiors.
2. **Schedules:** operator-confirmed opening/closing times, explicit days closed, holidays, gallery exhibit dates, mass schedules versus sightseer access, reservation/appointment requirements, and breakfast-vs-dinner sub-schedules.
3. **Prices:** adult/student/senior admission eligibility, conservation park admission, gallery events, Panaad entry if any, dated food menus, and what is optional versus required. Do **not** substitute a made-up budget range.
4. **Routing:** exact park/gateway and venue entrances plus venue-specific decimal coordinates where absent; validate OSM-center coordinates before routing.
5. **Photos:** select individual media files, record the photographer, exact reuse license or owner consent, URL, access date, required attribution, and permitted app usage.
6. **Accessibility/constraints:** ramps, parking, restroom availability, guided-tour or worship restrictions and crowd/event closures; none is asserted in this seed.
7. **Data freshness:** venue telephone/social-media confirmation for pages without an explicit recent update, and retry inaccessible Bacolod Tourism and provincial articles.

## S1-02 seed implementation

- Canonical research dataset: `supabase/data/locations.json` (10 records).
- Data migration: `supabase/migrations/20261014154651_seed_sample_locations.sql`.
- JSON structure, field types, duplicate names, coordinate pairs, costs, weekday
  intervals, and visit durations passed the implementation validation on 2026-10-14.
- Selected venue/government/mapping pages were re-opened during implementation;
  the freshness and access limitations above still apply. Structural validation
  does not establish current operating status for every destination.
- Sample UUIDs are deterministic UUIDv5 values using `NAMESPACE_URL` and the name
  `lagaw:locations:` followed by the trimmed, case-folded destination name.
  The SQL includes these fixed IDs; it does not regenerate them at application startup.
- `ON CONFLICT (id) DO NOTHING` makes rerunning the insert safe and preserves
  existing records, including administrator edits. Subsequent changes after
  deployment require a new migration rather than editing this applied file.
- Unknown values and editorial estimates are preserved from the research JSON.
  The Museum price bounds span published eligibility classes; the lower bound
  must not be interpreted as a universally available adult ticket price.
