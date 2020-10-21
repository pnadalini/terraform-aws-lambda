const AWS = require("aws-sdk");

const dynamodb = new AWS.DynamoDB.DocumentClient();

class dynamoTable {
  constructor(tableName) {
    this.tableName = tableName;
  }

  create = async (document, additionalParams = {}) => {
    const params = {
      TableName: this.tableName,
      Item: document,
      ...additionalParams,
    };

    return dynamodb.put(params).promise();
  };
}

module.exports = dynamoTable;
