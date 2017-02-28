/**
 * Created by beuttlerma on 09.02.17.
 */
var PaymentSchema = {
    type: 'object',
    properties: {
        paymentBIP70: {
            type: 'string',
            required: true
        }
    },
    required: true
};


module.exports = PaymentSchema;