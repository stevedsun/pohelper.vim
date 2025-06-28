local M = {}

local templates = {
	pbi = [=[
## PBI: {title}
**As a** {role}, **I want** {feature}, **so that** {benefit}

### Acceptance Criteria
- [ ] ...
]=],
	meeting = [=[
# Meeting: {topic}
**Date:** {date}   **Attendees:** {attendees}

## Agenda
1.
2.

## Notes

## Action Items
- [ ] Action: {item} @
]=],
}

function M.get(name)
	return templates[name]
end

return M
