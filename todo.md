# Todo:

## V0

### General
- [] Add a logger instead of puts
- [] Loose Error strategy

### Schema Cache
- [x] Download Schemas from Github
- [x] Age out after set intervals
- [x] check cache every run

### Query Definitions and Results
- [] Compose Queries to be used (hardcode the options)
- [] Move to Composing queries with Vars
- [] Define a value object to parse Queries out into instead of just results and then struct diving
- [] Fragmenting! Is it useful? Does it add overhead? How does it change the structure?

### Perf
- [] Measure Speed of queries, is it fast enough to perform per session-request
-

## V1 (Dreams)
- [] Auth without hardcoded token
- [] Rails api setup
- [] RSpec setup
- [] Cache Query Results
- [] Save Multiple Users and Teams
- [] Setup Wiz
- [] Rake task to download schemas, DB vs File (deployment dependant?)?
