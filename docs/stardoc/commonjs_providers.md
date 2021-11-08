<!-- Generated with Stardoc: http://skydoc.bazel.build -->

<a id="#CjsInfo"></a>

## CjsInfo

<pre>
CjsInfo(<a href="#CjsInfo-descriptor">descriptor</a>, <a href="#CjsInfo-prefix">prefix</a>, <a href="#CjsInfo-id">id</a>, <a href="#CjsInfo-root">root</a>)
</pre>

CommonJS-style package

**FIELDS**

| Name                                      | Description                 |
| :---------------------------------------- | :-------------------------- |
| <a id="CjsInfo-descriptor"></a>descriptor | Descriptor file             |
| <a id="CjsInfo-prefix"></a>prefix         | Default prexfix for entries |
| <a id="CjsInfo-id"></a>id                 | ID                          |
| <a id="CjsInfo-root"></a>root             | Root struct                 |

<a id="#cjs_path"></a>

## cjs_path

<pre>
cjs_path(<a href="#cjs_path-id">id</a>)
</pre>

**PARAMETERS**

| Name                       | Description               | Default Value |
| :------------------------- | :------------------------ | :------------ |
| <a id="cjs_path-id"></a>id | <p align="center"> - </p> | none          |

<a id="#create_entry"></a>

## create_entry

<pre>
create_entry(<a href="#create_entry-root">root</a>, <a href="#create_entry-name">name</a>, <a href="#create_entry-file">file</a>, <a href="#create_entry-label">label</a>)
</pre>

Create entry for CommonJS package.

**PARAMETERS**

| Name                                 | Description               | Default Value |
| :----------------------------------- | :------------------------ | :------------ |
| <a id="create_entry-root"></a>root   | Root ID                   | none          |
| <a id="create_entry-name"></a>name   | Name                      | none          |
| <a id="create_entry-file"></a>file   | File                      | none          |
| <a id="create_entry-label"></a>label | <p align="center"> - </p> | none          |

<a id="#create_entry_set"></a>

## create_entry_set

<pre>
create_entry_set(<a href="#create_entry_set-entries">entries</a>, <a href="#create_entry_set-entry_sets">entry_sets</a>)
</pre>

**PARAMETERS**

| Name                                               | Description               | Default Value   |
| :------------------------------------------------- | :------------------------ | :-------------- |
| <a id="create_entry_set-entries"></a>entries       | <p align="center"> - </p> | <code>[]</code> |
| <a id="create_entry_set-entry_sets"></a>entry_sets | <p align="center"> - </p> | <code>[]</code> |

<a id="#create_extra_link"></a>

## create_extra_link

<pre>
create_extra_link(<a href="#create_extra_link-root">root</a>, <a href="#create_extra_link-dep">dep</a>, <a href="#create_extra_link-label">label</a>)
</pre>

Create extra dep for CommonJs package.

**PARAMETERS**

| Name                                      | Description               | Default Value |
| :---------------------------------------- | :------------------------ | :------------ |
| <a id="create_extra_link-root"></a>root   | <p align="center"> - </p> | none          |
| <a id="create_extra_link-dep"></a>dep     | <p align="center"> - </p> | none          |
| <a id="create_extra_link-label"></a>label | <p align="center"> - </p> | none          |

<a id="#create_link"></a>

## create_link

<pre>
create_link(<a href="#create_link-dep">dep</a>, <a href="#create_link-name">name</a>, <a href="#create_link-label">label</a>)
</pre>

Create link for CommonJs package.

**PARAMETERS**

| Name                                | Description   | Default Value |
| :---------------------------------- | :------------ | :------------ |
| <a id="create_link-dep"></a>dep     | Dependency ID | none          |
| <a id="create_link-name"></a>name   | Name          | none          |
| <a id="create_link-label"></a>label | Source label  | none          |

<a id="#create_root"></a>

## create_root

<pre>
create_root(<a href="#create_root-id">id</a>, <a href="#create_root-name">name</a>, <a href="#create_root-descriptor">descriptor</a>, <a href="#create_root-links">links</a>)
</pre>

Create root.

**PARAMETERS**

| Name                                          | Description                | Default Value |
| :-------------------------------------------- | :------------------------- | :------------ |
| <a id="create_root-id"></a>id                 | ID                         | none          |
| <a id="create_root-name"></a>name             | Name                       | none          |
| <a id="create_root-descriptor"></a>descriptor | package.json descriptor    | none          |
| <a id="create_root-links"></a>links           | List of dependency structs | none          |

<a id="#entry_json"></a>

## entry_json

<pre>
entry_json(<a href="#entry_json-entry">entry</a>)
</pre>

**PARAMETERS**

| Name                               | Description               | Default Value |
| :--------------------------------- | :------------------------ | :------------ |
| <a id="entry_json-entry"></a>entry | <p align="center"> - </p> | none          |

<a id="#entry_runfile_json"></a>

## entry_runfile_json

<pre>
entry_runfile_json(<a href="#entry_runfile_json-entry">entry</a>)
</pre>

**PARAMETERS**

| Name                                       | Description               | Default Value |
| :----------------------------------------- | :------------------------ | :------------ |
| <a id="entry_runfile_json-entry"></a>entry | <p align="center"> - </p> | none          |

<a id="#extra_link_json"></a>

## extra_link_json

<pre>
extra_link_json(<a href="#extra_link_json-extra_link">extra_link</a>)
</pre>

**PARAMETERS**

| Name                                              | Description               | Default Value |
| :------------------------------------------------ | :------------------------ | :------------ |
| <a id="extra_link_json-extra_link"></a>extra_link | <p align="center"> - </p> | none          |

<a id="#link_json"></a>

## link_json

<pre>
link_json(<a href="#link_json-link">link</a>)
</pre>

**PARAMETERS**

| Name                            | Description               | Default Value |
| :------------------------------ | :------------------------ | :------------ |
| <a id="link_json-link"></a>link | <p align="center"> - </p> | none          |

<a id="#root_json"></a>

## root_json

<pre>
root_json(<a href="#root_json-root">root</a>)
</pre>

**PARAMETERS**

| Name                            | Description               | Default Value |
| :------------------------------ | :------------------------ | :------------ |
| <a id="root_json-root"></a>root | <p align="center"> - </p> | none          |

<a id="#root_runfile_json"></a>

## root_runfile_json

<pre>
root_runfile_json(<a href="#root_runfile_json-root">root</a>)
</pre>

**PARAMETERS**

| Name                                    | Description               | Default Value |
| :-------------------------------------- | :------------------------ | :------------ |
| <a id="root_runfile_json-root"></a>root | <p align="center"> - </p> | none          |
