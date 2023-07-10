CREATE TABLE Users(
    UserId int NOT NULL PRIMARY KEY,
    Email varchar(30),
    BirthdayDate datetime,
    CityId int,
    Alias varchar(20),
    AmountOfWallets int,
    TotalBalance decimal(10,2),
    InitialAvgBalance decimal(10,2)
);

CREATE TABLE LoginHistory(
    UserId int NOT NULL PRIMARY KEY,
    LoginDate datetime,
    IpAdress varchar(30),
    CONSTRAINT fk_Users foreign key (UserId) REFERENCES Users(UserId),
);