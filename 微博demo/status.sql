
-- 创建微博数据表 --


CREATE TABLE IF NOT EXISTS "T_Status" (
"statusid" INTEGER NOT NULL,
"userid" INTEGER NOT NULL,
"status" TEXT,
"creatTimer" TEXT DEFAULT (datetime('now','localtime')),
PRIMARY KEY("statusid","userid")
);
