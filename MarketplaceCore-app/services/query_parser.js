function parseObject(query) {
    const result = {};

    for (let key in query) {
        if (query.hasOwnProperty(key)) {
            const value = query[key];

            if (typeof value === 'string') {
                if (!isNaN(value)) {
                    result[key] = parseFloat(query[key]);
                }
                else if(value.toLowerCase() === 'true') {
                    result[key] = true
                }
                else if(value.toLowerCase() === 'false') {
                    result[key] = false
                }
                else {
                    result[key] = value;
                }
            }
            else if (value.constructor === Object) {
                result[key] = parseObject(value);
            }
            else if (value.constructor === Array) {
                const parsedArray = [];
                for (let i in value) {
                    if (!isNaN(value[i])) {
                        parsedArray.push(parseFloat(value[i]));
                    }
                    else {
                        parsedArray.push(value[i]);
                    }
                }
                result[key] = parsedArray;
            }
            else {
                result[key] = value;
            }
        }

    }

    return result;
}

module.exports = function (req, res, next) {
    req.query = parseObject(req.query);
    next();
};