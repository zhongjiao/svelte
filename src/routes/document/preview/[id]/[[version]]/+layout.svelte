<script>
import '/src/main.css';
import Header from "./header.svelte";

/** @type {import('./$types').PageData} */
export let data

const documentData = data.data
const {name, dateType, updateTime, effectTime} = documentData.data

const headerProps = {
  name,
  dateType,
  updateTime,
  effectTime
}

</script>

<Header {...headerProps}></Header>
<slot></slot>

