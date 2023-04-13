--Zadanie 1

db.pracownicy.find()

{ "_id" : ObjectId("63b56414cfe1822f354a821c"), "id_prac" : 100, "nazwisko" : "WEGLARZ", "placa_pod" : 1730 }
{ "_id" : ObjectId("63b56426cfe1822f354a821d"), "id_prac" : 100, "nazwisko" : "WEGLARZ", "placa_pod" : 1730 }
{ "_id" : 100, "id_prac" : 100, "nazwisko" : "WEGLARZ", "placa_pod" : 1730 }
{ "_id" : ObjectId("63b5646dcfe1822f354a821e"), "id_prac" : 110, "nazwisko" : "BLAZEWICZ", "placa_pod" : 1350, "zatrudniony" : ISODate("1973-05-01T00:00:00Z") }

Odp. W kolekcji pracownicy są 4 dokumenty, a data została zapisana w następującym formacie: ISODate("1973-05-01T00:00:00Z")


--Zadanie 2

db.zespoly.insert([
{"id_zesp":10,"nazwa":"ADMINISTRACJA","adres":"PIOTROWO 3A"},
{"id_zesp":20,"nazwa":"SYSTEMY ROZPROSZONE","adres":"PIOTROWO 3A"},
{"id_zesp":30,"nazwa":"SYSTEMY EKSPERCKIE","adres":"STRZELECKA 14"},
{"id_zesp":40,"nazwa":"ALGORYTMY","adres":"WLODKOWICA 16"},
{"id_zesp":50,"nazwa":"BADANIA OPERACYJNE","adres":"MIELZYNSKIEGO 30"}
])


--Zadanie 3

db.pracownicy.find({"etat":"PROFESOR"}, {"nazwisko":1, "_id":0})
/* 1 */
{
    "nazwisko" : "BLAZEWICZ"
}...

db.pracownicy.find({"etat":"PROFESOR"}, {"nazwisko":0, "_id":0})
/* 1 */
{
    "id_prac" : 110.0,
    "etat" : "PROFESOR",
    "id_szefa" : 100.0,
    "zatrudniony" : ISODate("1973-05-01T00:00:00.000Z"),
    "placa_pod" : 1350.0,
    "placa_dod" : 210.0,
    "id_zesp" : 40.0
}...

db.pracownicy.find({"etat":"PROFESOR"}, {"nazwisko":1, "placa_pod":0})
Error: error: {
        "ok" : 0,
        "errmsg" : "Projection cannot have a mix of inclusion and exclusion.",
        "code" : 2,
        "codeName" : "BadValue"
}

Odp. Pierwszy wynik wyświetla tylko nazwisko, natomiast drugi wyświetla całą zawartość dokumentu poza nazwiskiem. Ostatnie zapytanie pokazuje, że nie możemy jednocześnie wymagać (1) i odrzucać (0) wyświetlanych danych.


--Zadanie 4

db.pracownicy.find(
{$or:[{"etat":"ASYSTENT"},
{$and:[{"placa_pod":{$gt:200}, "placa_pod":{$lt:500}}]}]},
{"nazwisko":1, "etat":1, "placa_pod":1}
)


--Zadanie 5

db.pracownicy.find(
{"placa_pod":{$gt:400}},
{"nazwisko":1, "etat":1, "placa_pod":1}
).sort(
{"etat":1, "placa_pod":-1})


--Zadanie 6

db.pracownicy.find(
{"id_zesp":20},
{"nazwisko":1, "placa_pod":1}
).sort(
{"placa_pod":-1}).skip(1).limit(1)


--Zadanie 7

db.pracownicy.find(
{"etat":{$ne:"ASYSTENT"},"nazwisko":{$regex:"I$"},
"id_zesp":{$in:[20,30]}},
{"nazwisko":1}
)


--Zadanie 8

db.pracownicy.aggregate([
 {$project: {
     stanowisko: "$etat",
     nazwisko: "$nazwisko",
     rok_zatrudnienia: {$year: "$zatrudniony"},
     placa_pod: "$placa_pod",
     }
 },
 {$sort: { placa_pod: -1 }},
 {$skip: 2},
 {$limit: 1}
])


--Zadanie 9

db.pracownicy.aggregate([
 {$group:{
    _id: "$id_zesp",
    liczba: {$sum: 1}
    }
 },
 {$match: { liczba: {$gt:3} }}
])


--Zadanie 10

db.pracownicy.aggregate([
 {$match:{ $or: [{"id_zesp": 20}, {"id_zesp": 30}]}},
 {$lookup:{from: "zespoly",
 localField: "id_zesp",
 foreignField: "id_zesp",
 as: "zespol_pracownika"}
 },
{$project:{"nazwisko":1,
 "dept": {$arrayElemAt:["$zespol_pracownika.adres",0]}
 }
 }
])


--Zadanie 11

db.zespoly.aggregate([
 {$lookup:{from: "pracownicy",
 localField: "id_zesp",
 foreignField: "id_zesp",
 as: "pracownik"}
 },
 {$match: {adres: { $regex: /STRZELECKA/i}}},
 {$project:{"pracownik.nazwisko":1, "nazwa":1}
 }
])


--Zadanie 12

db.zespoly.aggregate([
    {$lookup:{from: "pracownicy",
         localField: "id_zesp",
         foreignField: "id_zesp",
         as: "pracownik"}
     },
    {$project: {
            _id: 0,
            liczba: { $size: "$pracownik" },
            nazwa: 1}
    },
    {$match: { liczba: {$gt:0} }}
])


--Zadanie 13

var pracownicy = db.pracownicy.find();
var zespoly = db.zespoly.find();
while (pracownicy.hasNext()) {
 prac = pracownicy.next();
 zesp = db.zespoly.findOne({"id_zesp": prac.id_zesp});
 db.pracownicy.update(
     { _id: prac._id },
     {$set: {id_zesp:zesp._id}});
}


--Zadanie 14

db.produkty.find(
 {"oceny.osoba":  {"$nin":["Ania","Karol"]}},
 {_id:0, nazwa:1}
)


--Zadanie 15

db.produkty.aggregate([
 {$unwind : "$oceny" },
 {$group: {
 _id:"$_id",
 nazwa: {$first: "$nazwa"},
 srednia_ocena: {$avg: "$oceny.ocena"}
 }
 },
 {$project: {
     _id: 0,
     produkt: "$nazwa",
     srednia_ocena: 1
 }},
 {$sort: { srednia_ocena: -1 }},
 {$limit: 1}
])


--Zadanie 16

db.produkty.update(
  { nazwa: "Kosiarka elektryczna" },
  { $push: { oceny: { osoba: "Ania", ocena: 4 } } }
)


--Zadanie 17

db.produkty.aggregate([
    {
        $match: {
            oceny: {
              $elemMatch: {
                osoba: "Ania",
                ocena: 4
              }
            }
        }
    },
    
    {
        $addFields: {
        czy_tylko_ania_dała_4: {
          $cond: {
            if: {
              $eq: [
                {
                  $size: {
                    $filter: {
                      input: "$oceny",
                      as: "ocena",
                      cond: {
                        $eq: ["$$ocena.ocena", 4]
                      }
                    }
                  }
                }, 1]
            },
            then: true,
            else: false
          }
        }
      }
    },
    
    {
      $match: {
        czy_tylko_ania_dała_4: true
      }
    },
    
    {
        $project: {
            "_id" : "$nazwa"
        }
    }
    
  ])


--Zadanie 18

db.produkty.updateMany(
    {},
    {$pull: {oceny: {ocena: {$lte: 3}}}}
)