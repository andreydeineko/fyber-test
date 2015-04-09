## Ruby Developer Challenge
The whole idea of this challenge is to use the Fyber API and render the results of the
response. For solving the problem Rails framework was choosen (no surprise here).

## Steps teken


1. Create a form asking for the params (uid, pub0 and page)
2. Make the request to the API passing the params and the authentication hash
3. Get the result from the response.
4. Check the returned hash to check that it is a real response (check signature)
5. Render the offers in a view:
If we have offers there we render them (title, thumbnail lowres and payout)
If we have no offers there we render a message like ‘No offers’
6. Create functional and unit tests (choose your tool: TestUnit, RSpec, Shoulda...)
* Params used

```
#!ruby

appid: 157
format: json
device_id: “2b6f0cc904d137be2e1730235f5664094b831186”
locale: de
ip: 109.235.143.113 (german IP)
offer_types: 112
API Key: b07a12df7d52e6c118e5d47d3f9e60135b109a1f
```


## Testing
For testing purpose MiniTest framework was choosen (just to remind myself again that Rspec is way more explicit in it's syntax).


It is treated to be an antipattern to test private methods, but for the sake of peacefull sleep I've tested few core ones.