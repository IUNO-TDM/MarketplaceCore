const moment = require('moment');

var reports_helper = {};


reports_helper.fill_gaps_revenue_history = function (from, to, data) {
    const startDate = moment.utc(from);
    const endDate = moment.utc(to);

    var dates = [];
    var date = startDate.startOf('day');
    do {
        dates.push(date.toDate());
        date.add(1, 'day');
    } while (date.isBefore(endDate));


    var no_gap_data = {};
    for (var i in data) {
        if (!no_gap_data[(data[i].technologydataname)]) {
            no_gap_data[data[i].technologydataname] = [];

            for (var j in dates) {
                no_gap_data[data[i].technologydataname].push({
                    date: dates[j],
                    revenue: "0",
                    technologydataname: data[i].technologydataname
                });
            }
        }
        var date = data[i].date;
        var d2 = moment.utc([date.getFullYear(), date.getMonth(), date.getDate()]).toDate();

        function indexOfDate(element) {
            return (element.getTime() == d2.getTime());
        }

        var k = dates.findIndex(indexOfDate);
        if (k != -1) {
            no_gap_data[data[i].technologydataname][k].revenue = data[i].revenue;
        } else {
            log.warn("The date " + d2 + "could not be sorted into the list");
        }

    }

    var returnvalue = [];
    for (var i in no_gap_data) {
        returnvalue = returnvalue.concat(no_gap_data[i]);
    }
    return returnvalue;
}
reports_helper.fill_gaps_total_revenue = function (from, to, detail, data) {
    console.log(moment().format());
    const startDate = moment.utc(from);
    const endDate = moment.utc(to);

    const hourly = detail === 'hour';


    var dates = [];
    if (hourly) {
        var date = startDate.startOf('hour');
        do {
            dates.push(date.toDate());
            date.add(1, 'hour');
        } while (date.isBefore(endDate));
    } else {
        var date = startDate.startOf('day');
        do {
            dates.push(date.toDate());
            date.add(1, 'day');
        } while (date.isBefore(endDate));
    }


    var no_gap_data = {};
    for (var i in data) {
        if (!no_gap_data[(data[i].technologydataname)]) {
            no_gap_data[data[i].technologydataname] = [];

            for (var j in dates) {
                var emptyDataset = {
                    date: dates[j],
                    revenue: "0",
                    technologydataname: data[i].technologydataname,
                    hour: "0",
                    amount: 0
                };
                if (hourly) {
                    emptyDataset.hour = dates[j].getUTCHours().toString();
                }
                no_gap_data[data[i].technologydataname].push(emptyDataset);
            }
        }
        var date = data[i].date;
        var d2 = moment.utc([date.getFullYear(), date.getMonth(), date.getDate(), data[i].hour]).toDate();

        function indexOfDate(element) {
            return (element.getTime() == d2.getTime());
        }

        var k = dates.findIndex(indexOfDate);
        if (k != -1) {
            no_gap_data[data[i].technologydataname][k].revenue = data[i].revenue;
            no_gap_data[data[i].technologydataname][k].amount = data[i].amount;
        } else {
            log.warn("The date " + d2 + "could not be sorted into the list");
        }

    }

    var returnvalue = [];
    for (var i in no_gap_data) {
        returnvalue = returnvalue.concat(no_gap_data[i]);
    }
    return returnvalue;
}

module.exports = reports_helper;