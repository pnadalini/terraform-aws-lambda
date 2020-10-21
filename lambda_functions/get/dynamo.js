const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB.DocumentClient();

class dynamoTable {
  constructor(tableName) {
    this.tableName = tableName;
  }
  
  scan = async (additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      ...additionalParams,
    };

    const items = [];
    let continueFlag = false;
    do {
      const result = await dynamodb.scan(params).promise();
      items.push(...result.Items);

      // scan can retrieve a maximum of 1MB of data
      if (typeof result.LastEvaluatedKey !== "undefined") {
        console.info("Scanning for results...");
        params.ExclusiveStartKey = result.LastEvaluatedKey;

        continueFlag = true;
      } else {
        continueFlag = false;
      }
    } while (continueFlag);

    return items;
  };
}

module.exports = dynamoTable;
