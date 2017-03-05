# jsonAccess

```
library(jsonAccess)
```

Assume you have the following JSON string:

```
json <- "{\"a\": {\"b\": 8, \"c\": [1,2]}, \"b\": [10.14, 11.618]}"
```


```
json <- 
"{
  \"a\": {
    \"b\": 8,
    \"c\": [
      1,
      [
        2,
        \"x\"
      ]
    ]
  },
  \"b\": null
}"
```

- Access to the value of the key `"a"`:

```
> jsonAccess(json, "a")
## "{\"b\":8,\"c\":[1,[2,\"x\"]]}"
```

- Try to access to a key which is not there:

```
> jsonAccess(json, "z")
## "null"
```


- Access to the value of the key `"b"` in the value of the key `"a"`:

```
> jsonAccess(json, c("a","b"))
## "8"
```

- Acces to the array in key `"c"`:

```
> ( Array <- jsonAccess(json, c("a","c")) )
## "[1,[2,\"x\"]]"
```

- Get its 1-th element:

```
> jsonElemAt(Array, 1)
## "[2,\"x\"]"
```

- Get an element only if it is a number:

```
> jsonElemAt_ifNumber(Array, 0)
## "1"
> jsonElemAt_ifNumber(Array, 1)
## "null"
```

- Chain: 

```
> jsonAccess(json, c("a","c")) %>% jsonElemAt(1) %>% jsonElemAt(1)
## "\"x\""
```
