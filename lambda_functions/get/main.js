"use strict";

exports.handler = async (event, context, callback) => {
  const DynamoTable = require("./dynamo"); 
  const table = new DynamoTable(process.env.TABLE_NAME);

  const names = await table.scan();

  const response = {
    statusCode: 200,
    headers: {},
    body: JSON.stringify(names),
    isBase64Encoded: false,
  };
  callback(null, response);
};
