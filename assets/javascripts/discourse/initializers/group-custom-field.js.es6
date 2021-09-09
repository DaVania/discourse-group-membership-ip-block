import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "group-custom-field",
  initialize() {
    withPluginApi("0.8.30", (api) => {
      api.modifyClass("model:group", {
        custom_fields: {},
        asJSON() {
          return Object.assign(this._super(), {
            custom_fields: this.custom_fields,
          });
        },
      });
    });
  },
};
