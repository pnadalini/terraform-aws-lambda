"use strict";

exports.handler = async (event, context, callback) => {
  const DynamoTable = require("./dynamo");
  const table = new DynamoTable(process.env.TABLE_NAME);
  const { v4: uuidv4 } = require("uuid");

  console.debug("processing event", { context: event });

  const request = JSON.parse(event.body);
  const newName = {
    UserId: uuidv4(),
    ...request,
  };

  console.debug("Inserted name", newName);

  await table.create(newName);

  const body = {
    message: "Created",
  };

  const response = {
    statusCode: 200,
    headers: {},
    body: JSON.stringify(body),
    isBase64Encoded: false,
  };

  callback(null, response);
};
