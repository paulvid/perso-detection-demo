    CREATE TABLE article_evaluation (
        web_url VARCHAR NOT NULL PRIMARY KEY,
        snippet VARCHAR,
        byline  VARCHAR,
        pub_date TIMESTAMP,
        headline VARCHAR,
        document_type  VARCHAR,
        news_desk  VARCHAR,
        filename  VARCHAR,
        last_updated VARCHAR,
        extraversion DOUBLE,
        emotional_stability DOUBLE,
        agreeableness DOUBLE,
        conscientiousness DOUBLE,
        openness_to_experience DOUBLE
    );
    
    CREATE TABLE article_stats (
    web_url VARCHAR NOT NULL PRIMARY KEY,
    views TINYINT,
    last_updated VARCHAR
    );
    
    CREATE TABLE article_popularity_prediction (
    web_url VARCHAR NOT NULL PRIMARY KEY,
    extraversion DOUBLE,
    emotional_stability DOUBLE,
    agreeableness DOUBLE,
    conscientiousness DOUBLE,
    openness_to_experience DOUBLE,
    prediction DOUBLE
    );