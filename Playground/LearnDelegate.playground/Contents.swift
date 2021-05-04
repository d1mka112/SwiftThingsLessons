struct Cookie {
    var size: Int = 5
    var hasChocolateChips: Bool = false
}

protocol BakeryDelegate {
    func cookieWasBaked(_ cookie: Cookie)
}

protocol BakeryRequestDelegate {
    func makeCookie(num: Int)
}

class Bakery : BakeryRequestDelegate {
    var delegate: BakeryDelegate?
    
    func makeCookie(num: Int) {
        let cookie = Cookie(size: num, hasChocolateChips: true)
        print(cookie.size)
        delegate?.cookieWasBaked(cookie)
    }

}

class Deliver: BakeryDelegate {
    var delegate: BakeryRequestDelegate?
    var countCookie: Int = 0
    func getCookie(_ num: Int) {
        delegate?.makeCookie(num: num)
    }
    func cookieWasBaked(_ cookie: Cookie) {
        countCookie = countCookie + cookie.size
        print(cookie.hasChocolateChips)
    }
}

var deliver = Deliver()
var bakery = Bakery()

deliver.delegate = bakery
bakery.delegate = deliver

deliver.getCookie(5)
deliver.getCookie(10)
print(deliver.countCookie)
deliver.getCookie(15)
print(deliver.countCookie)


