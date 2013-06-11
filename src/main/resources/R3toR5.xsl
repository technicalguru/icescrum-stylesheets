<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="xml" indent="yes"/>
	<!-- xsl:strip-space elements="*"/ -->

	<xsl:template match="/product">
    	<export version="R5#1.2">
	
		<product>
			<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
			<pkey><xsl:value-of select="pkey"/></pkey>
			<planningPokerGameType><xsl:value-of select="planningPokerGameType"/></planningPokerGameType>
			<startDate><xsl:value-of select="startDate"/></startDate>
			<endDate><xsl:value-of select="endDate"/></endDate>
			<lastUpdated>2012-08-15 14:21:14</lastUpdated>
			<dateCreated>2012-08-15 14:15:23</dateCreated>
			<name><xsl:value-of select="name"/></name>
			<description><xsl:value-of select="description"/></description>
			
			<xsl:apply-templates select="preferences"/>
			<xsl:apply-templates select="teams"/>
			<xsl:apply-templates select="releases"/>
			<xsl:apply-templates select="actors"/>
			<xsl:apply-templates select="features"/>
			<xsl:apply-templates select="stories"/>
			<xsl:apply-templates select="cliches"/>
			<xsl:apply-templates select="productOwners"/>
		</product>
		
    	</export>
	</xsl:template>
	
	<xsl:template match="/product/preferences">
		<preferences>
			<hidden><xsl:value-of select="hidden"/></hidden>
			<url><xsl:value-of select="url"/></url>
			<noEstimation><xsl:value-of select="noEstimation"/></noEstimation>
			<autoDoneStory><xsl:value-of select="autoDoneStory"/></autoDoneStory>
			<displayRecurrentTasks><xsl:value-of select="displayRecurrentTasks"/></displayRecurrentTasks>
			<displayUrgentTasks><xsl:value-of select="displayUrgentTasks"/></displayUrgentTasks>
			<assignOnCreateTask><xsl:value-of select="assignOnCreateTask"/></assignOnCreateTask>
			<assignOnBeginTask><xsl:value-of select="assignOnBeginTask"/></assignOnBeginTask>
			<autoCreateTaskOnEmptyStory><xsl:value-of select="autoCreateTaskOnEmptyStory"/></autoCreateTaskOnEmptyStory>
			<limitUrgentTasks><xsl:value-of select="limitUrgentTasks"/></limitUrgentTasks>
			<estimatedSprintsDuration><xsl:value-of select="estimatedSprintsDuration"/></estimatedSprintsDuration>
			<hideWeekend><xsl:value-of select="hideWeekend"/></hideWeekend>
			<sprintPlanningHour><xsl:value-of select="sprintPlanningHour"/></sprintPlanningHour>
			<releasePlanningHour><xsl:value-of select="releasePlanningHour"/></releasePlanningHour>
			<dailyMeetingHour><xsl:value-of select="dailyMeetingHour"/></dailyMeetingHour>
			<sprintReviewHour><xsl:value-of select="sprintReviewHour"/></sprintReviewHour>
			<sprintRetrospectiveHour><xsl:value-of select="sprintRetrospectiveHour"/></sprintRetrospectiveHour>
			<timezone>Europe/Berlin</timezone>
		</preferences>
	</xsl:template>
	
	<xsl:template match="/product/teams">
		<teams>
		<xsl:for-each select="team">
			<team>
				<xsl:attribute name="uid">md5:<xsl:value-of select="@id"/>:<xsl:value-of select="name"/></xsl:attribute>
				<id><xsl:value-of select="@id"/></id>
				<velocity><xsl:value-of select="velocity"/></velocity>
				<dateCreated><xsl:value-of select="dateCreated"/></dateCreated>
				<name><xsl:value-of select="name"/></name>
				<description><xsl:value-of select="description"/></description>
				<xsl:apply-templates select="preferences"/>
				<xsl:apply-templates select="members"/>
				<xsl:apply-templates select="scrumMasters"/>
			</team>
		</xsl:for-each>
		</teams>
	</xsl:template>
	
	<xsl:template match="/product/teams/team/preferences">
		<preferences>
			<allowNewMembers><xsl:value-of select="allowNewMembers"/></allowNewMembers>
		</preferences>
	</xsl:template>
	
	<xsl:template match="members">
		<members>
			<xsl:apply-templates select="user"/>
		</members>
	</xsl:template>
	
	<xsl:template match="user">
		<user>
			<xsl:attribute name="uid">md5:<xsl:value-of select="@id"/>:<xsl:value-of select="username"/><xsl:value-of select="email"/></xsl:attribute>
			<id><xsl:value-of select="@id"/></id>
			<username><xsl:value-of select="username"/></username>
			<password><xsl:value-of select="password"/></password>
			<email><xsl:value-of select="email"/></email>
			<dateCreated><xsl:value-of select="dateCreated"/></dateCreated>
			<enabled><xsl:value-of select="enabled"/></enabled>
			<accountExpired><xsl:value-of select="accountExpired"/></accountExpired>
			<accountLocked><xsl:value-of select="accountLocked"/></accountLocked>
			<passwordExpired><xsl:value-of select="passwordExpired"/></passwordExpired>
			<accountExternal><xsl:value-of select="accountExternal"/></accountExternal>
			<lastName><xsl:value-of select="lastName"/></lastName>
			<firstName><xsl:value-of select="firstName"/></firstName>
			<preferences>
				<language><xsl:value-of select="preferences/language"/></language>
				<activity><xsl:value-of select="preferences/activity"/></activity>
				<filterTask>allTasks</filterTask>
				<menu>[project:1, sprintPlan:6, releasePlan:5, backlog:3, sandbox:2, timeline:4]</menu>
				<menuHidden>[feature:2, actor:1]</menuHidden>
				<hideDoneState>false</hideDoneState>
			</preferences>
			<teams>
				<xsl:for-each select="teams/team">
				<team>
					<xsl:attribute name="uid">team:<xsl:value-of select="@id"/></xsl:attribute>
				</team>
				</xsl:for-each>
			</teams>
		</user>
	</xsl:template>
	
	<xsl:template match="scrumMasters">
		<scrumMasters>
			<xsl:for-each select="scrumMaster">
				<scrumMaster>
					<xsl:attribute name="uid">user:<xsl:value-of select="@id"/></xsl:attribute>
				</scrumMaster>
			</xsl:for-each>
		</scrumMasters>
	</xsl:template>
	
	<xsl:template match="releases">
		<releases>
		<xsl:for-each select="release">
			<release>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				<state><xsl:value-of select="state"/></state>
				<releaseVelocity><xsl:value-of select="releaseVelocity"/></releaseVelocity>
				<endDate><xsl:value-of select="endDate"/></endDate>
				<startDate><xsl:value-of select="startDate"/></startDate>
				<orderNumber><xsl:value-of select="orderNumber"/></orderNumber>
				<lastUpdated>2012-08-15 14:19:19</lastUpdated>
				<dateCreated>2012-08-15 14:15:24</dateCreated>
				<name><xsl:value-of select="name"/></name>
				<vision><xsl:value-of select="vision"/></vision>
				<description><xsl:value-of select="description"/></description>
				<goal><xsl:value-of select="goal"/></goal>
				<xsl:apply-templates select="sprints"/>
			</release>
		</xsl:for-each>
		</releases>
	</xsl:template>
	
	<xsl:template match="sprints">
		<sprints>
		<xsl:for-each select="sprint">
			<sprint>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				<state><xsl:value-of select="state"/></state>
				<dailyWorkTime><xsl:value-of select="dailyWorkTime"/></dailyWorkTime>
				<velocity><xsl:value-of select="velocity"/></velocity>
				<capacity><xsl:value-of select="capacity"/></capacity>
				<resource><xsl:value-of select="resource"/></resource>
				<endDate><xsl:value-of select="endDate"/></endDate>
				<startDate><xsl:value-of select="startDate"/></startDate>
				<orderNumber><xsl:value-of select="orderNumber"/></orderNumber>
				<activationDate><xsl:value-of select="activationDate"/></activationDate>
				<closeDate><xsl:value-of select="closeDate"/></closeDate>
				<lastUpdated><xsl:value-of select="activationDate"/></lastUpdated>
				<dateCreated><xsl:value-of select="activationDate"/></dateCreated>
				<retrospective><xsl:value-of select="retrospective"/></retrospective>
				<doneDefinition><xsl:value-of select="doneDefinition"/></doneDefinition>
				<description><xsl:value-of select="description"/></description>
				<goal><xsl:value-of select="goal"/></goal>
				<xsl:apply-templates select="tasks"/>
				<xsl:apply-templates select="stories"/>
				<xsl:apply-templates select="cliches"/>
			</sprint>
		</xsl:for-each>
		</sprints>
	</xsl:template>
	
	<xsl:template match="tasks">
		<tasks>
		<xsl:for-each select="task">
			<task>
				<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
				<estimation><xsl:value-of select="estimation"/></estimation>
				<type><xsl:value-of select="type"/></type>
				<state><xsl:value-of select="state"/></state>
				<rank><xsl:value-of select="rank"/></rank>
				<creationDate><xsl:value-of select="creationDate"/></creationDate>
				<inProgressDate><xsl:value-of select="inProgressDate"/></inProgressDate>
				<doneDate><xsl:value-of select="doneDate"/></doneDate>
				<blocked><xsl:value-of select="blocked"/></blocked>
				<color>yellow</color>
				<name><xsl:value-of select="name"/></name>
				<description><xsl:value-of select="description"/></description>
				<notes><xsl:value-of select="notes"/></notes>
				<creator>
					<xsl:attribute name="uid">user:<xsl:value-of select="creator/@id"/></xsl:attribute>
				</creator>
				<responsible>
					<xsl:if test="responsible/@id != ''">
						<xsl:attribute name="uid">user:<xsl:value-of select="responsible/@id"/></xsl:attribute>
					</xsl:if>
				</responsible>
				<attachments/>
			</task>
		</xsl:for-each>
		</tasks>
	</xsl:template>
	
	<xsl:template match="stories">
		<stories>
		<xsl:for-each select="story">
			<story>
				<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
				<state><xsl:value-of select="state"/></state>
				<suggestedDate><xsl:value-of select="suggestedDate"/></suggestedDate>
				<acceptedDate><xsl:value-of select="acceptedDate"/></acceptedDate>
				<estimatedDate><xsl:value-of select="estimatedDate"/></estimatedDate>
				<plannedDate><xsl:value-of select="plannedDate"/></plannedDate>
				<inProgressDate><xsl:value-of select="inProgressDate"/></inProgressDate>
				<doneDate><xsl:value-of select="doneDate"/></doneDate>
				<effort><xsl:value-of select="effort"/></effort>
				<value><xsl:value-of select="value"/></value>
				<rank><xsl:value-of select="rank"/></rank>
				<creationDate><xsl:value-of select="creationDate"/></creationDate>
				<type><xsl:value-of select="type"/></type>
				<executionFrequency><xsl:value-of select="executionFrequency"/></executionFrequency>
				<name><xsl:value-of select="name"/></name>
				<textAs><xsl:value-of select="textAs"/></textAs>
				<textICan><xsl:value-of select="textICan"/></textICan>
				<textTo><xsl:value-of select="textTo"/></textTo>
				<notes><xsl:value-of select="notes"/></notes>
				<description><xsl:value-of select="description"/></description>
				<creator>
					<xsl:attribute name="uid">user:<xsl:value-of select="creator/@id"/></xsl:attribute>
				</creator>
				<feature>
					<xsl:if test="feature/@id != ''">
						<xsl:attribute name="uid"><xsl:value-of select="feature/@id"/></xsl:attribute>
					</xsl:if>
				</feature>
				<actor>
					<xsl:if test="actor/@id != ''">
						<xsl:attribute name="uid"><xsl:value-of select="actor/@id"/></xsl:attribute>
					</xsl:if>
				</actor>
				<xsl:apply-templates select="tasks"/>
				<comments/>
				<activities/>
				<acceptanceTests/>
				<attachments/>
			</story>
		</xsl:for-each>
		</stories>
	</xsl:template>
	
	<xsl:template match="cliches">
		<cliches>
		<xsl:for-each select="cliche">
			<cliche>
				<xsl:attribute name="id"><xsl:value-of select="@id"/></xsl:attribute>
				<datePrise><xsl:value-of select="datePrise"/></datePrise>
				<type><xsl:value-of select="type"/></type>
				<data><xsl:value-of select="data"/></data>
			</cliche>
		</xsl:for-each>
		</cliches>
	</xsl:template>
	
	<xsl:template match="actors">
		<actors>
		<xsl:for-each select="actor">
			<actor>
				<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
				<instances><xsl:value-of select="instances"/></instances>
				<expertnessLevel><xsl:value-of select="expertnessLevel"/></expertnessLevel>
				<useFrequency><xsl:value-of select="useFrequency"/></useFrequency>
				<creationDate><xsl:value-of select="creationDate"/></creationDate>
				<name><xsl:value-of select="name"/></name>
				<satisfactionCriteria><xsl:value-of select="satisfactionCriteria"/></satisfactionCriteria>
				<notes><xsl:value-of select="notes"/></notes>
				<description><xsl:value-of select="description"/></description>
				<stories>
					<xsl:for-each select="stories/story">
					<story>
						<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
					</story>
					</xsl:for-each>
				</stories>
				<attachments/>
			</actor>
		</xsl:for-each>
		</actors>
	</xsl:template>
	
	<xsl:template match="features">
		<features>
		<xsl:for-each select="feature">
			<feature>
				<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
				<color><xsl:value-of select="color"/></color>
				<value><xsl:value-of select="value"/></value>
				<type><xsl:value-of select="type"/></type>
				<rank><xsl:value-of select="rank"/></rank>
				<creationDate><xsl:value-of select="creationDate"/></creationDate>
				<name><xsl:value-of select="name"/></name>
				<notes><xsl:value-of select="notes"/></notes>
				<description><xsl:value-of select="description"/></description>
				<stories>
					<xsl:for-each select="stories/story">
					<story>
						<xsl:attribute name="uid"><xsl:value-of select="@id"/></xsl:attribute>
					</story>
					</xsl:for-each>
				</stories>
				<attachments/>
			</feature>
		</xsl:for-each>
		</features>
	</xsl:template>
	
	<xsl:template match="productOwners">
		<productOwners>
			<xsl:apply-templates select="user"/>
		</productOwners>
	</xsl:template>
</xsl:stylesheet>